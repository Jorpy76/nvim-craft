-- Comando de prueba para debuggear el clipboard
-- Usar en Neovim: :lua dofile('/home/jorgerios/.config/nvim/test-clipboard-nvim.lua')

print("=== TEST CLIPBOARD DESDE NEOVIM ===")

local img_dir = "/tmp/nvim-clipboard-test"
vim.fn.mkdir(img_dir, "p")

local png_tmp = img_dir .. "/test.png"
local webp_final = img_dir .. "/test.webp"

-- Limpiar
vim.fn.delete(png_tmp)
vim.fn.delete(webp_final)

-- 1. Verificar portapapeles
print("\n1. Verificando portapapeles...")
local check_targets = vim.fn.system("xclip -selection clipboard -t TARGETS -o 2>/dev/null")
print("TARGETS disponibles:")
print(check_targets)
print("Shell error:", vim.v.shell_error)

if vim.v.shell_error ~= 0 or check_targets == "" then
    print("❌ ERROR: Portapapeles vacío o xclip no funciona")
    return
end

-- 2. Intentar captura con múltiples formatos
print("\n2. Intentando captura de imagen...")
local formats = {"image/png", "image/x-png", "PNG"}
local captured = false

for _, fmt in ipairs(formats) do
    print("   Probando formato: " .. fmt)
    local cmd = string.format("xclip -selection clipboard -t %s -o > %q 2>/dev/null", fmt, png_tmp)
    vim.fn.system(cmd)
    
    local exists = vim.fn.filereadable(png_tmp)
    local size = vim.fn.getfsize(png_tmp)
    
    print(string.format("   - Archivo existe: %s, Size: %d bytes, Shell error: %d", 
        exists == 1 and "SI" or "NO", size, vim.v.shell_error))
    
    if vim.v.shell_error == 0 and exists == 1 and size > 100 then
        print("   ✅ CAPTURADO con " .. fmt)
        captured = true
        break
    else
        vim.fn.delete(png_tmp)
    end
end

if not captured then
    print("\n❌ FALLO: No se pudo capturar imagen")
    return
end

-- 3. Verificar tipo de archivo
print("\n3. Verificando tipo de archivo capturado...")
local file_type = vim.fn.system(string.format("file -b --mime-type %q", png_tmp)):gsub("%s+", "")
print("Tipo MIME: " .. file_type)

-- 4. Convertir a WebP
print("\n4. Convirtiendo a WebP...")
local cmd_convert = string.format("cwebp -q 80 %q -o %q 2>&1", png_tmp, webp_final)
local output = vim.fn.system(cmd_convert)

print("Salida de cwebp:")
print(output)
print("Shell error:", vim.v.shell_error)

local webp_exists = vim.fn.filereadable(webp_final)
local webp_size = vim.fn.getfsize(webp_final)

print(string.format("WebP existe: %s, Size: %d bytes", 
    webp_exists == 1 and "SI" or "NO", webp_size))

if vim.v.shell_error == 0 and webp_exists == 1 and webp_size > 100 then
    print("\n✅ ÉXITO TOTAL")
    print(string.format("PNG temporal: %s (%d KB)", png_tmp, math.floor(vim.fn.getfsize(png_tmp) / 1024)))
    print(string.format("WebP final: %s (%d KB)", webp_final, math.floor(webp_size / 1024)))
else
    print("\n❌ FALLO en conversión a WebP")
end
