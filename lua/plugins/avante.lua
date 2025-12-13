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
        -- 🔵 Provider por defecto (rápido)
        provider = "copilot_mini",
        auto_suggestions_provider = "copilot_mini",

        -- 🔵 Definición de providers (nuevo esquema, sin vendors)
        providers = {
            -- Base de Copilot (se hereda desde aquí)
            copilot = {
                endpoint = "https://api.githubcopilot.com",
                model = "gpt-4.1-mini", -- valor por defecto si usas "copilot" directo
                timeout = 30000,
                -- aquí irían cosas comunes si Avante las usa para Copilot,
                -- pero normalmente no hace falta más
            },

            -- RÁPIDO: GPT‑4.1-mini
            copilot_mini = {
                __inherited_from = "copilot",
                model = "gpt-4.1-mini",
                timeout = 30000,
                extra_request_body = {
                    temperature = 0.2,
                    max_completion_tokens = 4096,
                },
            },

            -- POTENTE: Claude 3.5 Sonnet
            copilot_claude = {
                __inherited_from = "copilot",
                model = "claude-3.5-sonnet",
                timeout = 30000,
                extra_request_body = {
                    temperature = 0.3,
                    max_completion_tokens = 8192,
                },
            },

            -- INTERMEDIO: GPT‑4.1
            copilot_gpt4 = {
                __inherited_from = "copilot",
                model = "gpt-4.1",
                timeout = 30000,
                extra_request_body = {
                    temperature = 0.2,
                    max_completion_tokens = 8192,
                },
            },

            -- Mantener Gemini por si acaso (opcional)
            gemini = {
                endpoint = "https://generativelanguage.googleapis.com/v1beta",
                model = "models/gemini-2.5-flash",
                timeout = 30000,
                extra_request_body = {
                    temperature = 0.7,
                    max_output_tokens = 2048,
                },
            },
        },
        -- 👇 tu sección de UI tal cual
        input = {
            provider = "snacks",
            provider_opts = {
                height = 10,
                border = "rounded",
                win_options = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    wrap = true,
                    linebreak = true,
                    scrolloff = 1,
                },
                style = {
                    padding_bottom = 1,
                },
            },
        },
        ui = {
            panel = {
                width = 0.35,
                min_width = 60,
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
        "zbirenbaum/copilot.lua", -- 🔵 importante para Copilot

        {
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

        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = { file_types = { "markdown", "Avante" } },
            ft = { "markdown", "Avante" },
        },
    },
}
