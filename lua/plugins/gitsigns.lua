return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
          signcolumn = true,
          numhl = true,
          max_file_length = 10000,
      })
    end,
  },
}
