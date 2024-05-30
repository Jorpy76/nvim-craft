return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				--null_ls.builtins.formatting.prettier,
				null_ls.builtins.diagnostics.erb_lint,
				null_ls.builtins.diagnostics.rubocop,
				null_ls.builtins.formatting.rubocop,
				null_ls.builtins.formatting.biome,
				null_ls.builtins.formatting.prettier.with({
					extra_filetypes = { "svelte", "astro" },
				}),
			},
			-- timeout_ms = 10000,
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		-- vim.keymap.set("n", "<leader>gf", function()
		-- 	vim.lsp.buf.format({
		-- 		async = false,
		-- 		timeout_ms = 10000, -- Tiempo de espera específico para el formateo
		-- 	})
		-- end, { desc = "Format file" })
	end,
}
