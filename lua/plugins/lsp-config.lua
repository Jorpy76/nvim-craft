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
        -- Flotantes: bordes y colores (Estilo Sobrio)
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
        -- Autoformat en guardado
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
        -- Keymaps en LspAttach (F4 para code actions)
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

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- =========================================================================
        -- mason + mason-lspconfig
        -- =========================================================================
        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = { "lua_ls", "intelephense", "ts_ls", "eslint", "tailwindcss" },
            handlers = {
                -- Handler genérico para la mayoría de servidores
                function(server_name)
                    -- Ignorar ltex porque lo maneja grammar-guard
                    if server_name == "ltex" then
                        return
                    end
                    
                    local server_filetypes = {
                        lua_ls       = { "lua" },
                        pyright      = { "python" },
                        ts_ls        = { "javascript", "javascriptreact", "typescript", "typescriptreact", "tsx", "jsx" },
                        eslint       = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
                        intelephense = { "php" },
                        tailwindcss  = { "html", "css", "javascriptreact", "typescriptreact", "astro" },
                    }

                    local ft = server_filetypes[server_name] or {}
                    local cfg = vim.lsp.config({
                        name = server_name,
                        filetypes = ft,
                        capabilities = capabilities,
                        settings = {},
                    })

                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = ft,
                        callback = function(ev)
                            local bufnr = ev.buf
                            local active = vim.lsp.get_clients({ name = server_name, bufnr = bufnr })
                            if active and #active > 0 then return end
                            vim.lsp.start(cfg, { bufnr = bufnr })
                        end,
                    })
                end,

                -- Handler específico para lua_ls
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
            },
        })
        
        -- Desactivar ltex standalone (usar solo grammar_guard)
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "ltex" then
                    vim.lsp.stop_client(client.id)
                end
            end,
        })
    end,
}
