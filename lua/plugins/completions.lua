return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local ls = require("luasnip")
            local mis_snippets = vim.fn.stdpath("config") .. "/snippets"
            require("luasnip.loaders.from_vscode").lazy_load({ paths = { mis_snippets } })
            require("luasnip.loaders.from_lua").lazy_load({ paths = { mis_snippets } })

            -- Extiende filetypes si es necesario
            ls.filetype_extend("javascriptreact", { "html" })
            ls.filetype_extend("typescriptreact", { "html" })
            ls.filetype_extend("astro", { "html" })
            ls.filetype_extend("svelte", { "html" })

            vim.keymap.set({ "i", "s" }, "<c-k>", function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end)
            vim.keymap.set({ "i", "s" }, "<c-j>", function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end)
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "luckasRanarison/tailwind-tools.nvim",
            "onsails/lspkind-nvim",
            "hrsh7th/cmp-emoji",
            "f3fora/cmp-spell",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            local tailwind_tools = require("tailwind-tools.cmp")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "obsidian",      priority = 1000 }, -- notas existentes
                    { name = "obsidian_new",  priority = 900 },  -- crear nuevas notas
                    { name = "obsidian_tags", priority = 800 },  -- tags

                    -- 🔹 Luego el resto
                    { name = "luasnip",       priority = 700 },
                    { name = "nvim_lsp",      priority = 500 },
                    { name = "spell",         priority = 400 },
                    { name = "emoji",         priority = 250 },
                }, {
                    { name = "buffer", priority = 100 },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text', -- Muestra Icono + Texto
                        maxwidth = 50,        -- Evita que el menú se ensanche demasiado
                        ellipsis_char = '...',
                        before = function(entry, vim_item)
                            -- 1. Mantenemos el formato de Tailwind (colores de clases)
                            vim_item = tailwind_tools.lspkind_format(entry, vim_item)

                            -- 2. Definimos iconos y etiquetas sobrias para tus fuentes
                            local menu_icon = {
                                obsidian      = "󰎚 [Nota]",
                                obsidian_new  = "󰎚  [Nueva]",
                                obsidian_tags = "󰓹 [Tag]",
                                spell         = "󰓆 [Esp]",
                                nvim_lsp      = " [LSP]",
                                luasnip       = "󰩫 [Snip]",
                                buffer        = "󰽙 [Buf]",
                                emoji         = "󰞅 [Emo]",
                            }

                            -- 3. Aplicamos la etiqueta al menú (lado derecho)
                            vim_item.menu = menu_icon[entry.source.name] or string.format("[%s]", entry.source.name)

                            return vim_item
                        end,
                    }),
                },
                completion = {
                    autocomplete = {
                        require("cmp.types").cmp.TriggerEvent.TextChanged,
                    },
                    keyword_length = 0, -- Sigue activo desde el primer carácter para fluidez total
                },
                completion = {
                    autocomplete = {
                        require("cmp.types").cmp.TriggerEvent.TextChanged,
                    },
                    keyword_length = 0, -- Activa desde el primer carácter
                },
            })
        end,
    },
}
