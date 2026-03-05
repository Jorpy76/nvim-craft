return {
    "brymer-meneses/grammar-guard.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("grammar-guard").init()
        
        -- Archivo para diccionario persistente
        local dict_dir = vim.fn.stdpath("config") .. "/spell"
        local dict_file_es = dict_dir .. "/dictionary-es.txt"
        local dict_file_en = dict_dir .. "/dictionary-en.txt"
        
        vim.fn.mkdir(dict_dir, "p")
        
        -- Función para cargar palabras desde archivo
        local function load_dictionary(file)
            if vim.fn.filereadable(file) == 0 then
                return {}
            end
            local words = {}
            for line in io.lines(file) do
                if line and line ~= "" then
                    table.insert(words, line)
                end
            end
            return words
        end
        
        -- Función para guardar palabra al archivo
        local function save_word_to_file(file, word)
            local f = io.open(file, "a")
            if f then
                f:write(word .. "\n")
                f:close()
            end
        end
        
        -- Cargar diccionarios existentes
        local dict_es = load_dictionary(dict_file_es)
        local dict_en = load_dictionary(dict_file_en)
        
        require("lspconfig").grammar_guard.setup({
            cmd = { 'ltex-ls' },
            filetypes = { "markdown", "tex", "latex", "plaintext" },
            settings = {
                ltex = {
                    enabled = { "latex", "tex", "bib", "markdown", "plaintext" },
                    language = "es",
                    diagnosticSeverity = "information",
                    setenceCacheSize = 2000,
                    additionalRules = {
                        enablePickyRules = true,
                        motherTongue = "es",
                    },
                    trace = { server = "off" },
                    dictionary = {
                        ["es"] = dict_es,
                        ["en-US"] = dict_en,
                    },
                    disabledRules = {
                        ["es"] = { "COMILLAS_TIPOGRAFICAS" },
                        ["en-US"] = {},
                    },
                    hiddenFalsePositives = {
                        ["es"] = {},
                    },
                    markdown = {
                        nodes = {
                            CodeBlock = "ignore",
                            FencedCodeBlock = "ignore",
                            AutoLink = "ignore",
                            Code = "ignore",
                        },
                    },
                },
            },
        })
        
        -- Configurar keybinding para agregar palabras al diccionario
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.name == "grammar_guard" then
                    -- Agregar palabra individual
                    vim.keymap.set('n', '<leader>la', function()
                        -- Buscar el cliente grammar_guard activo
                        local gg_clients = vim.lsp.get_clients({ name = "grammar_guard" })
                        if #gg_clients == 0 then
                            vim.notify("grammar_guard no está activo", vim.log.levels.WARN)
                            return
                        end
                        
                        local gg_client = gg_clients[1]
                        local word = vim.fn.expand('<cword>')
                        local lang = gg_client.config.settings.ltex.language or "es"
                        
                        -- Determinar archivo según idioma
                        local file = (lang == "es") and dict_file_es or dict_file_en
                        
                        if not gg_client.config.settings.ltex.dictionary then
                            gg_client.config.settings.ltex.dictionary = {}
                        end
                        if not gg_client.config.settings.ltex.dictionary[lang] then
                            gg_client.config.settings.ltex.dictionary[lang] = {}
                        end
                        
                        -- Verificar si ya existe
                        for _, w in ipairs(gg_client.config.settings.ltex.dictionary[lang]) do
                            if w == word then
                                vim.notify("'" .. word .. "' ya está en el diccionario", vim.log.levels.INFO)
                                return
                            end
                        end
                        
                        -- Agregar a la memoria
                        table.insert(gg_client.config.settings.ltex.dictionary[lang], word)
                        
                        -- Guardar al archivo
                        save_word_to_file(file, word)
                        
                        -- Notificar al servidor
                        gg_client.notify('workspace/didChangeConfiguration', {
                            settings = gg_client.config.settings
                        })
                        
                        vim.notify("'" .. word .. "' → diccionario [" .. lang .. "] ✓", vim.log.levels.INFO)
                    end, { buffer = event.buf, desc = "Grammar: Agregar palabra al diccionario" })
                    
                    -- Agregar TODAS las palabras con errores ortográficos (solo MORFOLOGIK)
                    vim.keymap.set('n', '<leader>lA', function()
                        local gg_clients = vim.lsp.get_clients({ name = "grammar_guard" })
                        if #gg_clients == 0 then
                            vim.notify("grammar_guard no está activo", vim.log.levels.WARN)
                            return
                        end
                        
                        local gg_client = gg_clients[1]
                        local lang = gg_client.config.settings.ltex.language or "es"
                        local file = (lang == "es") and dict_file_es or dict_file_en
                        
                        -- Obtener diagnósticos del buffer actual
                        local diagnostics = vim.diagnostic.get(0, { 
                            namespace = vim.lsp.diagnostic.get_namespace(gg_client.id)
                        })
                        
                        local words_added = {}
                        local count = 0
                        
                        for _, diag in ipairs(diagnostics) do
                            -- Solo agregar errores ortográficos (MORFOLOGIK)
                            if diag.code and type(diag.code) == "string" and diag.code:match("MORFOLOGIK") then
                                -- Extraer la palabra del rango del diagnóstico
                                local line = vim.api.nvim_buf_get_lines(0, diag.lnum, diag.lnum + 1, false)[1]
                                if line then
                                    local word = line:sub(diag.col + 1, diag.end_col)
                                    
                                    -- Verificar si no está ya en el diccionario
                                    local exists = false
                                    if gg_client.config.settings.ltex.dictionary[lang] then
                                        for _, w in ipairs(gg_client.config.settings.ltex.dictionary[lang]) do
                                            if w == word then
                                                exists = true
                                                break
                                            end
                                        end
                                    end
                                    
                                    if not exists and not words_added[word] then
                                        if not gg_client.config.settings.ltex.dictionary then
                                            gg_client.config.settings.ltex.dictionary = {}
                                        end
                                        if not gg_client.config.settings.ltex.dictionary[lang] then
                                            gg_client.config.settings.ltex.dictionary[lang] = {}
                                        end
                                        
                                        table.insert(gg_client.config.settings.ltex.dictionary[lang], word)
                                        save_word_to_file(file, word)
                                        words_added[word] = true
                                        count = count + 1
                                    end
                                end
                            end
                        end
                        
                        if count > 0 then
                            gg_client.notify('workspace/didChangeConfiguration', {
                                settings = gg_client.config.settings
                            })
                            vim.notify(count .. " palabras agregadas al diccionario [" .. lang .. "] ✓", vim.log.levels.INFO)
                        else
                            vim.notify("No hay errores ortográficos para agregar", vim.log.levels.INFO)
                        end
                    end, { buffer = event.buf, desc = "Grammar: Agregar TODAS las palabras con error" })
                end
            end,
        })
    end,
}
