return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<c-y>",
                        next = "<M-.>",
                        prev = "<M-,>",
                        dismiss = "<C-]>",
                    },
                },
                panel = { enabled = false },
            })
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            debug = false,
            model = "gpt-4o", -- o "claude-3.5-sonnet" si tienes acceso
            temperature = 0.1,
        },
        keys = {
            { "<leader>cc", "<cmd>CopilotChatToggle<cr>",   desc = "Toggle Copilot Chat" },
            { "<leader>ce", "<cmd>CopilotChatExplain<cr>",  desc = "Explain code" },
            { "<leader>ct", "<cmd>CopilotChatTests<cr>",    desc = "Generate tests" },
            { "<leader>cf", "<cmd>CopilotChatFix<cr>",      desc = "Fix code" },
            { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
        },
    },
}
