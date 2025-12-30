return {
    "folke/zen-mode.nvim",
    opts = {
        window = {
            width = 80,                -- Ancho del área de código enfocada
            options = {
                signcolumn = "no",     -- Oculta los signos de diagnóstico
                number = false,        -- Desactiva los números de línea
                wrap = true,           -- Activa el ajuste de línea
                linebreak = true,      -- Activa la ruptura de línea
                relativenumber = true, -- No usa números relativos
            },
        },
    }
}
