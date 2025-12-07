-- Archivo lsp-config.lua compatible con Neovim 0.11+ y nvim-lspconfig v2+/v3
return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        -- =========================================================================
        -- Flotantes: bordes y colores
        -- =========================================================================
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts)
            opts = opts or {}
            opts.border = opts.border or 'rounded'
            return orig_util_open_floating_preview(contents, syntax, opts)
        end

        local function set_float_highlights()
            vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#2a6f97" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#18151c" })
        end
        set_float_highlights()
        vim.api.nvim_create_autocmd('ColorScheme', {
            pattern = '*',
            callback = set_float_highlights
        })

        -- =========================================================================
        -- Diagnósticos
        -- =========================================================================
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN]  = '▲',
                    [vim.diagnostic.severity.HINT]  = '⚑',
                    [vim.diagnostic.severity.INFO]  = '»',
                },
            },
        })

        -- =========================================================================
        -- Autoformat en guardado para filetypes específicos
        -- =========================================================================
        local autoformat_filetypes = { "lua" }
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if not client then return end
                if vim.tbl_contains(autoformat_filetypes, vim.bo[args.buf].filetype) then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({
                                formatting_options = { tabSize = 4, insertSpaces = true },
                                bufnr = args.buf,
                                id = client.id
                            })
                        end
                    })
                end
            end
        })

        -- =========================================================================
        -- Keymaps en LspAttach
        -- =========================================================================
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, opts)
                vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
            end,
        })

        -- =========================================================================
        -- Capabilities para nvim-cmp
        -- =========================================================================
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- =========================================================================
        -- mason + mason-lspconfig
        -- =========================================================================
        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { "lua_ls", "intelephense", "ts_ls", "eslint", "tailwindcss" },
            -- Usamos handlers custom con la API nueva (sin lspconfig.setup)
            handlers = {
                -- Handler por defecto para servidores comunes
                function(server_name)
                    -- Mapa de filetypes por servidor (mínimo necesario para LspStartOnBuf)
                    local server_filetypes = {
                        lua_ls       = { "lua" },
                        pyright      = { "python" },
                        tsserver     = { "javascript", "javascriptreact", "typescript", "typescriptreact", "tsx", "jsx" },
                        eslint       = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
                        intelephense = { "php" },
                    }

                    local ft = server_filetypes[server_name]
                    if not ft then
                        -- Fallback genérico si mason instala un server no mapeado
                        ft = {}
                    end

                    local cfg = vim.lsp.config({
                        name = server_name,
                        cmd = (function()
                            -- Deja que lspconfig determine el bin si está disponible sin “framework”
                            -- o confía en el PATH. Si quieres binarios de mason, puedes apuntar
                            -- a vim.fn.stdpath("data") .. "/mason/bin/<server>"
                            return nil
                        end)(),
                        filetypes = ft,
                        capabilities = capabilities,
                        -- settings vacíos por defecto; servers específicos se sobreescriben abajo
                        settings = {},
                    })

                    -- Autostart en buffers con filetype coincidente
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = ft,
                        callback = function(ev)
                            -- Evita arrancar duplicado
                            local bufnr = ev.buf
                            local active = vim.lsp.get_clients({ name = server_name, bufnr = bufnr })
                            if active and #active > 0 then return end
                            vim.lsp.start(cfg, { bufnr = bufnr })
                        end,
                    })
                end,

                -- lua_ls con settings
                lua_ls = function()
                    local ft = { "lua" }
                    local cfg = vim.lsp.config({
                        name = "lua_ls",
                        filetypes = ft,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                diagnostics = { globals = { 'vim' } },
                                workspace = { library = { vim.env.VIMRUNTIME } },
                            },
                        },
                    })
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = ft,
                        callback = function(ev)
                            local bufnr = ev.buf
                            local active = vim.lsp.get_clients({ name = "lua_ls", bufnr = bufnr })
                            if active and #active > 0 then return end
                            vim.lsp.start(cfg, { bufnr = bufnr })
                        end,
                    })
                end,

                -- tsserver (TypeScript/JavaScript)
                tsserver = function()
                    local ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "tsx", "jsx" }
                    local cfg = vim.lsp.config({
                        name = "tsserver",
                        filetypes = ft,
                        capabilities = capabilities,
                        settings = {},
                    })
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = ft,
                        callback = function(ev)
                            local bufnr = ev.buf
                            local active = vim.lsp.get_clients({ name = "tsserver", bufnr = bufnr })
                            if active and #active > 0 then return end
                            vim.lsp.start(cfg, { bufnr = bufnr })
                        end,
                    })
                end,

                -- eslint
                eslint = function()
                    local ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" }
                    local cfg = vim.lsp.config({
                        name = "eslint",
                        filetypes = ft,
                        capabilities = capabilities,
                        settings = {},
                    })
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = ft,
                        callback = function(ev)
                            local bufnr = ev.buf
                            local active = vim.lsp.get_clients({ name = "eslint", bufnr = bufnr })
                            if active and #active > 0 then return end
                            vim.lsp.start(cfg, { bufnr = bufnr })
                        end,
                    })
                end,

                -- intelephense
                intelephense = function()
                    local ft = { "php" }
                    local cfg = vim.lsp.config({
                        name = "intelephense",
                        filetypes = ft,
                        capabilities = capabilities,
                        settings = {},
                    })
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = ft,
                        callback = function(ev)
                            local bufnr = ev.buf
                            local active = vim.lsp.get_clients({ name = "intelephense", bufnr = bufnr })
                            if active and #active > 0 then return end
                            vim.lsp.start(cfg, { bufnr = bufnr })
                        end,
                    })
                end,

                -- tailwindcss
                tailwindcss = function()
                    local ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte",
                        "html", "css" }
                    local cfg = vim.lsp.config({
                        name = "tailwindcss",
                        filetypes = ft,
                        capabilities = capabilities,
                        settings = {},
                    })
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = ft,
                        callback = function(ev)
                            local bufnr = ev.buf
                            local active = vim.lsp.get_clients({ name = "tailwindcss", bufnr = bufnr })
                            if active and #active > 0 then return end
                            vim.lsp.start(cfg, { bufnr = bufnr })
                        end,
                    })
                end,
            },
        })

        -- =========================================================================
        -- nvim-cmp
        -- =========================================================================
        local cmp = require('cmp')
        require('luasnip.loaders.from_vscode').lazy_load()
        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = { completeopt = 'menu,menuone,noinsert' },
            window = { documentation = cmp.config.window.bordered() },
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer',  keyword_length = 3 },
                { name = 'luasnip', keyword_length = 2 },
            },
            snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    local n = entry.source.name
                    if n == 'nvim_lsp' then
                        item.menu = '[LSP]'
                    else
                        item.menu = string.format('[%s]', n)
                    end
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>']    = cmp.mapping.confirm({ select = false }),
                ['<C-f>']   = cmp.mapping.scroll_docs(5),
                ['<C-u>']   = cmp.mapping.scroll_docs(-5),
                ['<C-e>']   = cmp.mapping(function()
                    if cmp.visible() then cmp.abort() else cmp.complete() end
                end),
                ['<Tab>']   = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                ['<C-d>']   = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(1) then luasnip.jump(1) else fallback() end
                end, { 'i', 's' }),
                ['<C-b>']   = cmp.mapping(function(fallback)
                    local luasnip = require('luasnip')
                    if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
                end, { 'i', 's' }),
            }),
        })
    end,
}
