return { {
  -- File explore
  -- nvim-tree.lua - A file explorer tree for neovim written in lua
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opt = true
  },
  opts = {
    filters = {
      dotfiles = false
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = false
    },
    view = {
      adaptive_size = true,
      side = "left",
      width = 20,
      preserve_window_proportions = true
    },
    git = {
      enable = false,
      ignore = true
    },
    filesystem_watchers = {
      enable = true
    },
    actions = {
      open_file = {
        resize_window = false
      }
    },
    renderer = {
      root_folder_label = false,
      highlight_git = true,
      highlight_opened_files = "name",

      indent_markers = {
        enable = false
      },

      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = false
        },

        glyphs = {
          default = "󰈚",
          symlink = "",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
            symlink_open = "",
            arrow_open = "",
            arrow_closed = ""
          },
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌"
          }
        }
      }
    }
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end
} }

