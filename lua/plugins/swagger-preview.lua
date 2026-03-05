return {
    "vinnymeller/swagger-preview.nvim",
    -- Eliminamos el -g para que se instale dentro de la carpeta del plugin
    build = "npm install swagger-ui-watcher",
    -- Usamos 'opts' para que lazy ejecute el setup automáticamente
    opts = {
        port = 8000,
        host = "localhost",
    },
    config = function(_, opts)
        require("swagger-preview").setup(opts)
    end
}
