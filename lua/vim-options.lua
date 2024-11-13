vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.syntax = "enable"
vim.opt.cursorline = true
vim.g.background = "light"

vim.opt.swapfile = false
vim.wo.cursorline = true
vim.o.clipboard = "unnamedplus"

-- Guardar todos los archivos abiertos con Ctrl+s
vim.keymap.set("n", "<C-s>", ":wa<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:wa<CR>i", { noremap = true, silent = true })


-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.wo.number = true

-- Terminal
vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- NvimTree
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", {}) -- open/close
--vim.keymap.set("n", "<leader>er", ":NvimTreeRefresh<CR>", {}) -- refresh
--vim.keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", {}) -- search file

-- Buffers
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")

--Lazygit
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true })


-- Diffview
vim.keymap.set('n', 'gH', ':DiffviewFileHistory<CR>',{ noremap = true, silent = true } )
vim.keymap.set('n', 'gv', function()
  if next(require('diffview.lib').views) == nil then
    vim.cmd('DiffviewOpen')
  else
    vim.cmd('DiffviewClose')
  end
end,{ noremap = true, silent = true } )

--Rest

