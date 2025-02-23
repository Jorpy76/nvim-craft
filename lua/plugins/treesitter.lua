return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = {
        "astro",
        "bash",
        "css",
        "dockerfile",
        "gitignore",
        "graphql",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "sql",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}


