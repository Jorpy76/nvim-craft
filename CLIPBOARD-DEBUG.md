# 🔍 Diagnóstico de Problemas con Clipboard (xclip)

## Problema Reportado
Error intermitente: "no hay nada en el portapapeles" al usar el comando de Obsidian para pegar imágenes.

## Herramientas de Diagnóstico

### 1. Test desde Bash (Rápido)
```bash
~/.config/nvim/test-clipboard.sh
```

**Qué hace:**
- Verifica que xclip y cwebp estén instalados
- Muestra qué formatos están disponibles en el portapapeles
- Intenta capturar con múltiples formatos (image/png, image/x-png, PNG)
- Convierte a WebP
- Reporta éxito o error detallado

**Cuándo usarlo:** Antes de abrir Neovim, para verificar que el portapapeles tiene una imagen válida.

### 2. Test desde Neovim (Detallado)
```vim
:lua dofile('/home/jorgerios/.config/nvim/test-clipboard-nvim.lua')
```

**Qué hace:**
- Simula exactamente el proceso que usa el plugin de Obsidian
- Muestra información detallada de cada paso
- Guarda archivos de prueba en `/tmp/nvim-clipboard-test/`

**Cuándo usarlo:** Dentro de Neovim cuando el error ocurre, para capturar el estado exacto.

## Pasos para Diagnosticar el Error Intermitente

### Cuando el Error Ocurra:

1. **NO cierres Neovim ni cambies el portapapeles**

2. **Ejecuta el test dentro de Neovim:**
   ```vim
   :lua dofile('/home/jorgerios/.config/nvim/test-clipboard-nvim.lua')
   ```

3. **Captura la salida completa** (especialmente los TARGETS disponibles)

4. **Verifica desde terminal también:**
   ```bash
   xclip -selection clipboard -t TARGETS -o
   ```

5. **Intenta pegar de nuevo con el comando mejorado:**
   ```vim
   :ObsidianPasteImg nombre_imagen
   ```

## Mejoras Implementadas en el Plugin

### Versión Anterior (Problemática)
- ❌ Un solo intento con `image/png`
- ❌ Validación previa compleja que podía fallar
- ❌ Errores poco informativos
- ❌ No limpiaba archivos previos

### Versión Nueva (Robusta)
- ✅ Intenta 3 formatos: `image/png`, `image/x-png`, `PNG`
- ✅ Verifica TARGETS antes de intentar captura
- ✅ Mensajes detallados con emojis para cada paso
- ✅ Muestra formatos disponibles en caso de error
- ✅ Limpia archivos temporales automáticamente
- ✅ Muestra tamaño del archivo final
- ✅ Mejor manejo de `vim.v.shell_error`

## Posibles Causas del Error Intermitente

1. **Timeout del portapapeles:** Algunas aplicaciones limpian el portapapeles después de un tiempo
2. **Formato inconsistente:** La aplicación fuente cambia el formato (a veces PNG, a veces JPEG)
3. **Portapapeles múltiple:** X11 tiene PRIMARY y CLIPBOARD - podría haber confusión
4. **Race condition:** El portapapeles cambia entre la verificación y la captura

## Comandos Útiles para Debugging

```bash
# Ver qué hay en el portapapeles
xclip -selection clipboard -t TARGETS -o

# Ver el portapapeles PRIMARY (diferente a CLIPBOARD)
xclip -selection primary -t TARGETS -o

# Captura manual para probar
xclip -selection clipboard -t image/png -o > /tmp/test.png
file /tmp/test.png
```

## Si el Error Persiste

El nuevo código debería mostrar mensajes específicos:

1. **"El portapapeles está vacío o xclip no funciona"**
   → El sistema no detecta nada en el portapapeles

2. **"No se detectó imagen en el portapapeles"**
   → Hay algo en el portapapeles pero no es una imagen
   → Mostrará los formatos disponibles para investigar

3. **"Error en conversión a WebP"**
   → La imagen se capturó pero cwebp falló
   → Mostrará la salida de cwebp

Anota EXACTAMENTE qué mensaje aparece y los TARGETS disponibles cuando falle.
