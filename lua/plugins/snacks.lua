return {
  "folke/snacks.nvim",
  opts = {
    image = {
      enabled = true,
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
      },
      doc = {
        enabled = true,
        inline = true,
        float = true,
        max_width = 80,
        max_height = 40,
      },
      wo = {
        wrap = false,
        number = false,
        relativenumber = false,
        cursorcolumn = false,
        signcolumn = "no",
        foldcolumn = "0",
        list = false,
        spell = false,
        statuscolumn = "",
      },
    },  -- Coma añadida aquí
    indent = {
      enabled = true,
      char = "│",
      priority = 1,
      only_scope = false,
      only_current = false,
      hl = "SnacksIndent",
      
      scope = {
        enabled = true,
        priority = 200,
        char = "│",
        underline = false,
        only_current = false,
        hl = "SnacksIndentScope",
      },
      
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
        style = "out",
        easing = "linear",
        duration = {
          step = 20,
          total = 500,
        },
      },
      
      chunk = {
        enabled = false,
        only_current = false,
        priority = 200,
        hl = "SnacksIndentChunk",
        char = {
          corner_top = "┌",
          corner_bottom = "└",
          horizontal = "─",
          vertical = "│",
          arrow = ">",
        },
      },
    }  -- Llave de cierre para indent
  }  -- Llave de cierre para opts
}  -- Llave de cierre para return
