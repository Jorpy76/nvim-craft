return {
    "yetone/avante.nvim",
    build = function()
        if vim.fn.has("win32") == 1 then
            return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        else
            return "make"
        end
    end,
    event = "VeryLazy",
    version = false,

    opts = {
        provider = "gemini",
        providers = {
            gemini = {
                endpoint = "https://generativelanguage.googleapis.com/v1beta",
                model = "models/gemini-2.5-flash",
                timeout = 30000,
                extra_request_body = {
                    temperature = 0.7,
                    max_output_tokens = 2048, -- nombre correcto del parámetro
                },
            },
        },

        -- 👇 sección nueva de UI
        input = {
            provider = "snacks",
            provider_opts = {
                -- configuraciones del cuadro de entrada (AvanteInput)
                height = 10, -- aumenta a 10 líneas el área de escritura
                border = "rounded",
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    wrap = true,      -- permite que el texto salte de línea
                    linebreak = true, -- evita cortarlo a mitad de palabra
                    scrolloff = 1,    -- agrega margen arriba/abajo
                },
                -- a veces el contador de tokens se superpone: agregamos padding inferior
                style = {
                    padding_bottom = 1,
                },
            },
        },
        ui = {
            -- configuraciones del panel lateral
            panel = {
                width = 0.35,   -- 35% de la pantalla
                min_width = 60, -- mínimo 60 columnas para comodidad
                border = "rounded",
            },
        },
    },

    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "echasnovski/mini.pick",
        "nvim-telescope/telescope.nvim",
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
        "stevearc/dressing.nvim",
        "folke/snacks.nvim",
        "nvim-tree/nvim-web-devicons",

        { -- imágenes en prompts
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = { insert_mode = true },
                    use_absolute_path = true,
                },
            },
        },

        { -- render markdown bonito en el panel de Avante
            "MeanderingProgrammer/render-markdown.nvim",
            opts = { file_types = { "markdown", "Avante" } },
            ft = { "markdown", "Avante" },
        },
    },
}
