vim.g.mapleader = " "

-- Ajuste de líneas largas (Sintaxis moderna Lua)
vim.opt.wrap = true
vim.opt.showbreak = "↪ "
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.wrapscan = true
vim.opt.conceallevel = 2     -- 0: muestra todo, 2: oculta sintaxis para mostrar iconos
vim.opt.concealcursor = "nc" -- Mantiene oculta la sintaxis en modo normal y comando

-- Indentación y Tabulación
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

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


vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.wo.number = true

-- NvimTree
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", {}) -- open/close

-- Buffers
vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>")

--Lazygit
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>', { silent = true })


-- Diffview
vim.keymap.set('n', 'gH', ':DiffviewFileHistory<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gv', function()
    if next(require('diffview.lib').views) == nil then
        vim.cmd('DiffviewOpen')
    else
        vim.cmd('DiffviewClose')
    end
end, { noremap = true, silent = true })

--Zen-mode
vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', { noremap = true, silent = true })
--
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keymaps: Ctrl + h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Mover a la ventana izquierda" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Mover a la ventana de abajo" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Mover a la ventana de arriba" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Mover a la ventana derecha" })

-------------------------------------------------------------------------------
-- CONFIGURACIONES ESPECÍFICAS DE LENGUAJE (Autocmds)
-------------------------------------------------------------------------------

-- Comportamiento inteligente para Markdown/Obsidian
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        -- Continúa el prefijo (>, -, *, +) automáticamente al presionar Enter
        vim.opt_local.formatoptions:append("r")
        -- Define qué caracteres se consideran comentarios/prefijos de bloque
        -- n:> permite que los callouts de Obsidian se comporten como citas
        vim.opt_local.comments = "b:>,b:-,b:*,b:+,n:>"
    end
})
