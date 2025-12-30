return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-treesitter/nvim-treesitter",
        "folke/snacks.nvim",
    },
    opts = {
        legacy_commands = false,
        workspaces = {
            {
                name = "obsidian_vault",
                path = "/home/jorgerios/obsidian-vault",
            },
        },
        img_folder = "HELPERS/Images", -- Carpeta destino de tus imágenes

        templates = {
            subdir = "Templates",
            date_format = "%d-%m-%Y",
            time_format = "%H:%M",
        },

        callbacks = {
            enter_note = function(client, note)
                -- 1. Smart Action (<CR>)
                vim.keymap.set("n", "<cr>", function()
                    require("obsidian").util.smart_action()
                end, { buffer = true, desc = "Obsidian Smart Action" })

                -- 2. SCRIPT DE IMÁGENES (Con cálculo de ruta INFALIBLE)
                vim.keymap.set("n", "<leader>p", function()
                    local name = vim.fn.input("Nombre imagen (webp): ")
                    if name == "" then return end

                    -- A. Definir rutas absolutas
                    local vault_root = "/home/jorgerios/obsidian-vault" -- Sin slash final para evitar líos
                    local img_rel_dir = "HELPERS/Images"
                    local img_dir = vault_root .. "/" .. img_rel_dir

                    local safe_name = name:gsub(" ", "_")
                    local png_tmp = img_dir .. "/" .. safe_name .. ".png"
                    local webp_final = img_dir .. "/" .. safe_name .. ".webp"

                    -- B. Guardar imagen (xclip -> cwebp)
                    local cmd = string.format(
                        "xclip -selection clipboard -t image/png -o > %q && cwebp -q 80 %q -o %q && rm %q",
                        png_tmp, png_tmp, webp_final, png_tmp
                    )

                    print(" Procesando imagen...")
                    vim.fn.system(cmd)

                    if vim.fn.filereadable(webp_final) == 0 then
                        print(" Error: No se pudo guardar la imagen (revisa xclip/cwebp).")
                        return
                    end

                    -- C. CÁLCULO DE RUTA RELATIVA ROBUSTO (Sin adivinanzas)
                    -- Obtener el directorio donde está la nota que editas
                    local current_dir = vim.fn.expand("%:p:h")

                    -- Función local para calcular ruta relativa de A -> B
                    local function get_relative_path(start_path, end_path)
                        -- Normalizar slashes
                        local s = start_path:gsub("/+", "/")
                        local e = end_path:gsub("/+", "/")

                        -- Dividir en partes
                        local s_parts = vim.split(s, "/")
                        local e_parts = vim.split(e, "/")

                        -- Encontrar prefijo común
                        local i = 1
                        while s_parts[i] and e_parts[i] and s_parts[i] == e_parts[i] do
                            i = i + 1
                        end

                        -- Construir los "../" necesarios
                        local rel = {}
                        for j = i, #s_parts do
                            if s_parts[j] ~= "" then table.insert(rel, "..") end
                        end

                        -- Agregar la parte restante del destino
                        for j = i, #e_parts do
                            if e_parts[j] ~= "" then table.insert(rel, e_parts[j]) end
                        end

                        return table.concat(rel, "/")
                    end

                    -- Generar ruta exacta desde TU nota hasta LA imagen
                    local relative_path = get_relative_path(current_dir, webp_final)

                    -- D. Insertar enlace y refrescar
                    local link = string.format("![](%s)", relative_path)
                    vim.api.nvim_put({ link }, "c", true, true)

                    vim.schedule(function()
                        -- Forzamos un pequeño "toque" para que Snacks despierte
                        vim.cmd("checktime")
                        print("✓ Imagen: " .. safe_name .. " (Ruta: " .. relative_path .. ")")
                    end)
                end, { buffer = true, desc = "Pegar imagen WebP" })
            end,
        },
    },
}
