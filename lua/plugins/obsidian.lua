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
        -- 1. FIX: Elimina avisos de comandos antiguos
        legacy_commands = false,

        workspaces = {
            {
                name = "obsidian_vault",
                path = "/home/jorgerios/obsidian-vault",
            },
        },

        -- Gestión de adjuntos
        attachments = {
            folder = "HELPERS/Images",
            img_text_func = function(path)
                local name = vim.fs.basename(tostring(path))
                return string.format("![%s](%s)", name, name)
            end,
        },

        note_frontmatter = {
            disable_frontmatter = false,
            add_tags = true,
            add_aliases = true,
        },

        callbacks = {
            enter_note = function(client, note)
                -- Smart Action (Seguir links / Checkboxes)
                vim.keymap.set("n", "<cr>", function()
                    return require("obsidian").util.smart_action()
                end, { buffer = true, desc = "Obsidian Smart Action" })

                -- SCRIPT DE CAPTURA WEB-P (Versión corregida para Peek y Snacks)
                vim.keymap.set("n", "<leader>p", function()
                    local name = vim.fn.input("Nombre imagen (webp): ")
                    if name == "" then return end

                    -- Rutas base
                    local vault_root = "/home/jorgerios/obsidian-vault"
                    local img_dir = vault_root .. "/HELPERS/Images"

                    -- Crear directorio si no existe
                    vim.fn.mkdir(img_dir, "p")

                    local safe_name = name:gsub(" ", "_")
                    local png_tmp = img_dir .. "/" .. safe_name .. ".png"
                    local webp_final = img_dir .. "/" .. safe_name .. ".webp"

                    -- Limpiar archivos previos si existen
                    vim.fn.delete(png_tmp)
                    vim.fn.delete(webp_final)

                    -- Intentar capturar imagen con múltiples formatos
                    print("📋 Capturando imagen del portapapeles...")
                    
                    -- Verificar primero si es de Chromium/Brave (workaround para bug conocido)
                    local check_targets = vim.fn.system("xclip -selection clipboard -t TARGETS -o 2>/dev/null")
                    local is_chromium = check_targets:find("chromium") ~= nil
                    local captured = false
                    
                    if is_chromium then
                        print("⚠️  Detectado Chromium/Brave...")
                        
                        -- Intentar obtener URL de la imagen del portapapeles
                        local image_url = vim.fn.system("xclip -selection clipboard -o 2>/dev/null"):gsub("%s+$", "")
                        
                        -- Verificar si parece una URL de imagen
                        if image_url:match("^https?://") and (image_url:match("%.png") or image_url:match("%.jpg") or image_url:match("%.jpeg") or image_url:match("%.webp")) then
                            print("📥 Descargando imagen desde URL...")
                            local cmd_download = string.format("curl -sL %q -o %q 2>&1", image_url, png_tmp)
                            vim.fn.system(cmd_download)
                            
                            if vim.v.shell_error == 0 and vim.fn.filereadable(png_tmp) == 1 and vim.fn.getfsize(png_tmp) > 100 then
                                print("✓ Imagen descargada correctamente")
                                captured = true
                            else
                                vim.fn.delete(png_tmp)
                            end
                        end
                        
                        -- Si no se descargó, intentar PRIMARY selection
                        if not captured then
                            print("   Intentando PRIMARY selection...")
                            local cmd_primary = string.format("xclip -selection primary -t image/png -o > %q 2>/dev/null", png_tmp)
                            vim.fn.system(cmd_primary)
                            
                            if vim.fn.filereadable(png_tmp) == 1 and vim.fn.getfsize(png_tmp) > 100 then
                                print("✓ Capturado desde PRIMARY selection")
                                captured = true
                            else
                                vim.fn.delete(png_tmp)
                            end
                        end
                    end
                    
                    -- Si no capturó desde PRIMARY, intentar con CLIPBOARD normal
                    if not captured then
                        -- Delay para que el portapapeles se actualice
                        vim.cmd("sleep 200m")
                        
                        local formats = {"image/png", "PNG", "image/x-png", "image/x-portable-pixmap"}
                        
                        -- Intentar múltiples veces con delays incrementales
                        for attempt = 1, 2 do
                            for _, fmt in ipairs(formats) do
                                local cmd_capture = string.format("xclip -selection clipboard -t %s -o > %q 2>/dev/null", fmt, png_tmp)
                                vim.fn.system(cmd_capture)
                                
                                if vim.v.shell_error == 0 and vim.fn.filereadable(png_tmp) == 1 and vim.fn.getfsize(png_tmp) > 100 then
                                    print("✓ Capturado con formato: " .. fmt)
                                    captured = true
                                    break
                                else
                                    vim.fn.delete(png_tmp)
                                end
                            end
                            
                            if captured then break end
                            
                            -- Si primer intento falló, esperar un poco más
                            if attempt == 1 then
                                print("   Esperando portapapeles...")
                                vim.cmd("sleep 500m")
                            end
                        end
                    end

                    if not captured then
                        print("❌ Error: No hay imagen en el portapapeles")
                        
                        -- Ofrecer alternativa: seleccionar archivo
                        local response = vim.fn.input("¿Pegar desde archivo? (s/n): ")
                        if response:lower() == "s" then
                            local file_path = vim.fn.input("Ruta del archivo: ", "", "file")
                            if file_path ~= "" and vim.fn.filereadable(file_path) == 1 then
                                -- Copiar el archivo a png_tmp
                                vim.fn.system(string.format("cp %q %q", file_path, png_tmp))
                                if vim.fn.filereadable(png_tmp) == 1 and vim.fn.getfsize(png_tmp) > 100 then
                                    print("✓ Archivo cargado: " .. file_path)
                                    captured = true
                                end
                            end
                        end
                        
                        if not captured then
                            print("   💡 Tips:")
                            print("   • Brave/Chrome: Click derecho → 'Copiar imagen'")
                            print("   • Captura: Ctrl+Shift+S (sistema) o Flameshot")
                            print("   • HTB Labs: Guarda captura primero, luego úsala")
                            return
                        end
                    end
                    
                    -- 3. Convertir a WebP
                    print("🔄 Convirtiendo a WebP (q=80)...")
                    local cmd_convert = string.format("cwebp -q 80 %q -o %q 2>&1", png_tmp, webp_final)
                    local convert_output = vim.fn.system(cmd_convert)

                    if vim.v.shell_error ~= 0 or vim.fn.filereadable(webp_final) == 0 or vim.fn.getfsize(webp_final) < 100 then
                        print("❌ Error en conversión a WebP:")
                        print("   " .. convert_output)
                        vim.fn.delete(png_tmp)
                        return
                    end

                    -- 4. Limpiar PNG temporal
                    vim.fn.delete(png_tmp)
                    
                    local webp_size = math.floor(vim.fn.getfsize(webp_final) / 1024)
                    print(string.format("✅ Imagen guardada: %s.webp (%d KB)", safe_name, webp_size))

                    -- 2. FUNCIÓN PARA CALCULAR RUTA RELATIVA
                    local function get_rel_path(start, dest)
                        local s_parts = vim.split(start:gsub("/+", "/"), "/")
                        local d_parts = vim.split(dest:gsub("/+", "/"), "/")

                        local i = 1
                        while s_parts[i] and d_parts[i] and s_parts[i] == d_parts[i] do
                            i = i + 1
                        end

                        local rel = {}
                        -- '..' por cada nivel hacia atrás desde la nota
                        for j = i, #s_parts do table.insert(rel, "..") end
                        -- Ruta hacia adelante hasta la imagen
                        for j = i, #d_parts do table.insert(rel, d_parts[j]) end

                        return table.concat(rel, "/")
                    end

                    -- 3. Inserción del link con ruta relativa
                    -- Obtenemos el directorio actual de la nota que estás editando
                    local cur_dir = vim.fn.expand('%:p:h')

                    -- Calculamos la ruta exacta desde la nota hasta la imagen
                    local rel_path = get_rel_path(cur_dir, webp_final)

                    -- Creamos el link markdown estándar
                    local link = string.format("![%s](%s)", safe_name, rel_path)

                    vim.api.nvim_put({ link }, "c", true, true)

                    vim.schedule(function()
                        vim.cmd("checktime")
                        pcall(function() require("snacks").image.hover() end)
                    end)
                end, { buffer = true, desc = "Pegar imagen WebP" })
            end,
        },
    },
}
