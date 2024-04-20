return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",

  config = function()
    require("bufferline").setup({
      options = {
        numbers = "ordinal",
        separator_style = "thick",
        indicator_icon = "|",
        indicator = {
          style = "underline",
        },
      },
    })
  end,
}
