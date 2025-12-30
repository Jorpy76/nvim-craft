return {
    "dhruvasagar/vim-table-mode",
    ft = "markdown",
    config = function()
        vim.g.table_mode_corner = "|" -- Para que use | en las esquinas en vez de +
        -- Opcional: Activar automáticamente en archivos markdown
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = "markdown",
        --     command = "TableModeEnable"
        -- })
    end
}
