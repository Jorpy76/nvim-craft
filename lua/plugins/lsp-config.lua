return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Configuración de diagnósticos
      vim.diagnostic.config({
        virtual_text = false, -- Deshabilitar texto en línea
        float = {
          border = "rounded", -- Usar bordes redondeados para el popup
          source = "always",  -- Mostrar la fuente del mensaje
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Configuración de LSP
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.ts_ls.setup({
        capabilities = capabilities
      })
      lspconfig.solargraph.setup({
        capabilities = capabilities
      })
      lspconfig.html.setup({
        capabilities = capabilities
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        filetypes = {
          "html",
          "css",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "svelte",
          "astro",
        },
      })

      lspconfig.astro.setup({
        capabilities = capabilities,
        settings = {
          astro = {
            lint = {
              enabled = true, -- Habilitar el linter
            },
            diagnostics = {
              enable = true, -- Habilitar los diagnósticos
            },
          },
        },
      })
      lspconfig.prismals.setup({
        capabilities = capabilities
      })

      -- Keymaps para LSP
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

      -- Configuración del borde para el diagnóstico flotante
      vim.cmd [[
        highlight FloatBorder guifg=#FF5733 guibg=#282828 gui=bold
      ]]
    end,
  },
}
