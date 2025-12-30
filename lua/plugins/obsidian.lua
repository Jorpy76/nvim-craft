return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "obsidian_vault",
                path = "/home/jorgerios/obsidian-vault",
            },
        },

        img_folder = "HELPERS/Images",

        templates = {
            subdir = "Templates",
            date_format = "%d-%m-%Y",
            time_format = "%H:%M",
        },

        mappings = {
            -- AQUI EMPIEZA LA CORRECCIÓN DE SINTAXIS
            ["<leader>p"] = {
                action = function()
                    -- 1. Pedir nombre
                    local name = vim.fn.input("Nombre imagen (webp): ")
                    if name == "" then return end

                    -- 2. Rutas Maestras
                    local vault_root = "/home/jorgerios/obsidian-vault/"
                    local img_rel_path = "HELPERS/Images/" 
                    local img_abs_dir = vault_root .. img_rel_path
                    
                    -- Sanitizar nombre
                    local safe_name = name:gsub(" ", "_")
                    local png_tmp = img_abs_dir .. safe_name .. ".png"
                    local webp_final = img_abs_dir .. safe_name .. ".webp"

                    -- 3. Crear Imagen (xclip -> cwebp)
                    local cmd = string.format(
                        "xclip -selection clipboard -t image/png -o > %q && cwebp -q 80 %q -o %q && rm %q",
                        png_tmp, png_tmp, webp_final, png_tmp
                    )
                    
                    print(" Procesando imagen...")
                    vim.fn.system(cmd)

                    -- 4. Verificar creación
                    if vim.fn.filereadable(webp_final) == 0 then
                        print(" Error: No se generó el archivo. Revisa el portapapeles.")
                        return
                    end

                    -- 5. CÁLCULO MATEMÁTICO DE RUTA (Sin librerías externas)
                    local current_file = vim.fn.expand("%:p") or ""
                    
                    -- Verificamos si estamos dentro del Vault
                    if current_file == "" or string.find(current_file, vault_root, 1, true) == nil then
                        print(" ! Aviso: Nota fuera del Vault. Usando enlace simple.")
                        local link = string.format("![[%s%s.webp]]", img_rel_path, safe_name)
                        vim.api.nvim_put({ link }, "c", true, true)
                        return
                    end
                    
                    -- Magia matemática: Restamos la raíz y contamos profundidad
                    local internal_path = current_file:sub(#vault_root + 1)
                    local depth = select(2, internal_path:gsub("/", ""))
                    local back_path = string.rep("../", depth)
                    
                    -- Construye la ruta relativa final
                    local relative_path = back_path .. img_rel_path .. safe_name .. ".webp"

                    -- 6. Insertar enlace
                    local link = string.format("![](%s)", relative_path)
                    vim.api.nvim_put({ link }, "c", true, true)
                    
                    -- 7. Refresco
                    vim.defer_fn(function() 
                        vim.cmd("checktime") 
                        pcall(function() require("image").refresh() end)
                        print("✓ Imagen lista: " .. relative_path)
                    end, 200)
                end,
                opts = { buffer = true },
            }, -- <--- AQUÍ SE CIERRA CORRECTAMENTE EL MAPPING
        },
    },
}
