return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- 1. picker
        picker = {
            enabled = true
        },

        -- 2. imágenes
        image = {
            enabled = true,
            formats = {
                "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff",
                "heic", "avif", "mp4", "mov", "avi", "mkv", "webm", "pdf",
            },
            doc = {
                enabled = true,
                inline = true,
                float = true,
                max_width = 80,
                max_height = 40,
            },
            wo = {
                wrap = false,
                number = false,
                relativenumber = false,
                cursorcolumn = false,
                signcolumn = "no",
                foldcolumn = "0",
                list = false,
                spell = false,
                statuscolumn = "",
            },
        },

        -- 3. indentación
        indent = {
            enabled = true,
            char = "│",
            priority = 1,
            only_scope = false,
            only_current = false,
            hl = "SnacksIndent",

            scope = {
                enabled = true,
                priority = 200,
                char = "│",
                underline = false,
                only_current = false,
                hl = "SnacksIndentScope",
            },

            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                style = "out",
                easing = "linear",
                duration = {
                    step = 20,
                    total = 500,
                },
            },

            chunk = {
                enabled = false,
                only_current = false,
                priority = 200,
                hl = "SnacksIndentChunk",
                char = {
                    corner_top = "┌",
                    corner_bottom = "└",
                    horizontal = "─",
                    vertical = "│",
                    arrow = ">",
                },
            },
        },
    },
    keys = {
        -- Buscar archivos (Space + f + f)
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Buscar Archivos" },
        -- Buscar texto en todo el proyecto (Space + f + g)
        { "<leader>fg", function() Snacks.picker.grep() end,  desc = "Grep Texto" },
        -- Buscar Iconos / Emojis (Space + f + i)
        { "<leader>fi", function() Snacks.picker.icons() end, desc = "Buscar Iconos" },
    },
}
