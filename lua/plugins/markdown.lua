return {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- Solo se carga en archivos .md
    event = "VeryLazy",
    opts = {
        -- Mapeos por defecto (te explico los importantes abajo)
        mappings = {
            inline_surround_toggle = "gs", -- "Go Style" (Aplicar estilo)
            inline_surround_delete = "ds", -- "Delete Style" (Borrar estilo)
            inline_surround_change = "cs", -- "Change Style" (Cambiar estilo)
            link_add = "gl",               -- "Go Link" (Crear enlace)
            link_follow = "gx",            -- "Go eXternal" (Seguir enlace)
        },
        -- Configuración extra al abrir un archivo
        on_attach = function(bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr, silent = true }

            -- Atajo personalizado: Alt + c para marcar/desmarcar checkbox [ ] -> [x]
            map({ 'n', 'i' }, '<M-c>', '<Cmd>MDTaskToggle<CR>', opts)

            -- Atajo para crear items de lista rápidamente
            map('i', '<M-o>', '<Cmd>MDListItemBelow<CR>', opts)
        end,
    },
}
