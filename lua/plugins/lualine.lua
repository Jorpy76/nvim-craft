return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        globalstatus = true,
        theme = "catppuccin-mocha",
      },
      sections = {
        lualine_c = {
          { "filename" ,
           "file_status", path = 1 },
        },
      },
    })
  end,
}

