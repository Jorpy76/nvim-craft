return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

        -- Función para verificar si un formateador específico debe ejecutarse según el tipo de archivo.
        local function should_use_biome(filetype)
            local biome_filetypes = {
                json = true,
                css = true,
                graphql = true,
                javascript = true,
                javascriptreact = true,
                typescript = true,
                typescriptreact = true,
                jsonc = true,
            }
            return biome_filetypes[filetype] ~= nil
        end

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.biome.with({
                    condition = function(utils)
                        return should_use_biome(vim.bo.filetype) -- Verifica si debe usarse biome.
                    end,
                }),
                null_ls.builtins.formatting.prettier.with({
                    condition = function(utils)
                        return not should_use_biome(vim.bo.filetype)
                    end,
                    extra_filetypes = { "svelte", "astro" },
                }),
            },
            timeout_ms = 20000,
            autostart = true,
        })

        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
}

