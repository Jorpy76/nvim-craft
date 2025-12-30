return {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
        code = {
            enabled = true,
            sign = true,    -- Muestra el icono del lenguaje
            style = 'full', -- 'full' pone fondo al bloque completo
            width = 'block',
            left_pad = 2,   -- Añade padding a la izquierda como Obsidian
        },
        heading = {
            sign = false, -- Opcional: oculta los signos #
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- Iconos para H1-H6
        },
        file_types = { "markdown", "Avante" },
        render_modes = { "n", "c", "i" },
    },
    ft = { "markdown", "Avante" }, -- Soporte para tipos de archivo
}
