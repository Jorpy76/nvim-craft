return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require('toggleterm').setup({
            -- === CONFIGURACIÓN GENERAL ===
            -- Hemos quitado 'open_mapping' y 'direction' de aquí
            -- para que no haya una terminal "por defecto" preconfigurada.
            size = function(term)
                if term.direction == "horizontal" then
                    return 15                  -- 15 líneas para la horizontal
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4 -- 40% del ancho para la vertical
                end
            end,
            close_on_exit = true,
            shell = vim.o.shell,
            start_in_insert = true,
            persist_size = false,
            float_opts = {
                border = 'curved',
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.8),
            }
        })

        -- === DEFINICIÓN EXPLÍCITA DE ATAJOS ===
        -- Ahora cada atajo es independiente y define su propia dirección.

        -- Atajo para salir del modo terminal (sin cambios)
        vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

        -- 1. Atajo para la terminal HORIZONTAL (<c-t>)
        vim.keymap.set('n', '<c-t>', '<cmd>ToggleTerm direction=horizontal<CR>', {
            noremap = true,
            silent = true,
            desc = "Toggle horizontal terminal"
        })

        -- 2. Atajo para la terminal FLOTANTE (<leader>ft)
        vim.keymap.set('n', '<leader>ft', '<cmd>ToggleTerm direction=float<CR>', {
            noremap = true,
            silent = true,
            desc = "Toggle floating terminal"
        })

        -- === TERMINALES ESPECIALIZADAS (Sin cambios, esto ya estaba bien) ===
        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new({
            cmd = "lazygit",
            direction = "float",
            hidden = true,
            on_open = function(term)
                vim.cmd("setlocal nonumber norelativenumber")
            end
        })

        function _G.lazygit_toggle()
            lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>g", "<cmd>lua _G.lazygit_toggle()<CR>", {
            noremap = true,
            silent = true,
            desc = "Toggle lazygit"
        })
    end,
}
