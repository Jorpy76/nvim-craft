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
        -- 🔵 Provider correcto: "copilot" (no "copilot_mini")
        provider = "copilot",
        auto_suggestions_provider = "copilot",

        -- 🔵 NO definas providers personalizados para Copilot
        -- Avante usa directamente copilot.lua que ya tienes configurado

        -- Tu UI igual que antes
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

        -- 🔵 Importante: Avante necesita copilot.lua para el provider "copilot"
        "zbirenbaum/copilot.lua",

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
