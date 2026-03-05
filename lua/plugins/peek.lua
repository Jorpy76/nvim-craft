-- DESHABILITADO: Reemplazado por render-markdown.nvim
-- Si prefieres peek.nvim, descomenta este bloque y elimina render-markdown.lua

--[[ return {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
        require("peek").setup({
            auto_load = false,
            close_on_bdelete = true,
            syntax = true,
            theme = 'dark',
            update_on_change = true,
            app = 'webview',
        })

        local map = vim.keymap.set
        map("n", "<leader>mp", require("peek").open, { desc = "Markdown Peek Open" })
        map("n", "<leader>mc", require("peek").close, { desc = "Markdown Peek Close" })
    end,
}
--]]

return {}
