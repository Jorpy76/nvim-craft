return {
	"NvChad/nvim-colorizer.lua",

	config = function()
		require("colorizer").setup({
			user_default_options = {
				tailwind = true,
				css = true,
				html = true,
			},
		})
	end,
}
