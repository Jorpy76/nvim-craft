return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- 1. PICKER: Configurado para insertar nombres de archivos limpios
        picker = {
            enabled = true,
            win = {
                input = {
                    keys = {
                        -- Control + g para confirmar y pegar
                        ["<C-g>"] = { "confirm_path", mode = { "n", "i" } },
                    },
                },
            },
            actions = {
                confirm_path = function(picker)
                    local item = picker:current()
                    if not item then return end
                    picker:close()

                    -- Extraemos solo el nombre del archivo (ej: Hackthebox-cube.png)
                    -- Esto permite que la API de Obsidian lo encuentre solo
                    local filename = vim.fs.basename(item.file)
                    local link = string.format("![%s](%s)", filename, filename)

                    vim.schedule(function()
                        -- Inserta el formato Markdown completo
                        vim.api.nvim_put({ link }, "c", false, true)
                        vim.cmd("startinsert")
                    end)
                end,
            },
        },

        -- 2. IMÁGENES: Resolución nativa mediante la API del Fork
        image = {
            enabled = true,
            formats = { "png", "jpg", "jpeg", "gif", "bmp", "webp", "pdf" },
            resolve = function(path, src)
                local ok, api = pcall(require, "obsidian.api")
                if ok and api.path_is_note(path) then
                    -- La API busca el 'src' automáticamente en tu carpeta de adjuntos
                    return api.resolve_attachment_path(src)
                end
            end,
            doc = {
                enabled = true,
                inline = true,
                float = false,
                max_width = 80,
                max_height = 40,
            },
            wo = {
                wrap = false,
                signcolumn = "no",
                statuscolumn = "",
            },
        },

        -- 3. INDENTACIÓN
        indent = {
            enabled = true,
            char = "│",
            scope = { enabled = true, char = "│", hl = "SnacksIndentScope" },
            animate = {
                enabled = vim.fn.has("nvim-0.10") == 1,
                style = "out",
                duration = { step = 20, total = 500 },
            },
        },
    },

    -- 4. ATAJOS DE TECLADO
    keys = {
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Buscar Archivos" },
        { "<leader>fg", function() Snacks.picker.grep() end,  desc = "Grep Texto" },
        { "<leader>fi", function() Snacks.picker.icons() end, desc = "Buscar Iconos" },
        {
            "<leader>fp",
            function()
                Snacks.picker.files({
                    cwd = "/home/jorgerios/obsidian-vault/HELPERS/Images",
                    desc = "Imágenes Obsidian",
                })
            end,
            desc = "Picker de Imágenes"
        },
    },
}
