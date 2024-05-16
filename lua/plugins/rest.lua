return {
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
		opts = {
			rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
		},
	},

	{
		"rest-nvim/rest.nvim",
		ft = { "http" },
		lazy = true,
		dependencies = { "luarocks.nvim" },
		config = function()
      require("rest-nvim").setup()
		end,

		keys = {
			{
				"<leader>cr",
				"<cmd>Rest run<cr>",
				desc = "Run http request under the cursor",
			},
			{
				"<leader>cl",
				"<cmd>Rest run last<cr>",
				desc = "Re-run latest httplocalleader request",
			},
		},
	},
}
