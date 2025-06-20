return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "jayp0521/mason-null-ls.nvim", -- para auto instalar linters/formatters
    "nvimtools/none-ls-extras.nvim", -- para ruff y ruff_format
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    -- Función para verificar si un formateador específico debe ejecutarse según el tipo de archivo.
    local function should_use_biome(filetype)
      local biome_filetypes = {
        json = true,
        css = true,
        graphql = true,
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        jsonc = true,
      }
      return biome_filetypes[filetype] ~= nil
    end

    -- Mason-null-ls para instalar automáticamente herramientas
    require("mason-null-ls").setup({
      ensure_installed = {
        "prettier",
        "biome",
        "ruff",
        "ruff_format",
        -- agrega aquí otros linters/formatters que quieras
      },
      automatic_installation = true,
    })

    -- Agrupa los sources
    local sources = {
      -- Tu lógica de biome/prettier
      formatting.biome.with({
        condition = function(utils)
          return should_use_biome(vim.bo.filetype)
        end,
      }),
      formatting.prettier.with({
        condition = function(utils)
          return not should_use_biome(vim.bo.filetype)
        end,
        extra_filetypes = { "svelte", "astro" },
      }),
      -- Python: Ruff y Ruff Format
      require("none-ls.formatting.ruff").with({
        extra_args = { "--extend-select", "I" },
      }),
      require("none-ls.formatting.ruff_format"),
    }

    -- Autoformato al guardar (opcional, puedes quitar si no lo quieres)
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      sources = sources,
      timeout_ms = 20000,
      autostart = true,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
