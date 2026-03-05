#!/bin/bash

echo "=== DIAGNÓSTICO DE PORTAPAPELES XCLIP ==="
echo ""

# 1. Verificar herramientas
echo "1. Verificando herramientas instaladas..."
which xclip && echo "✓ xclip encontrado" || echo "✗ xclip NO encontrado"
which cwebp && echo "✓ cwebp encontrado" || echo "✗ cwebp NO encontrado"
echo ""

# 2. Ver qué hay en el portapapeles
echo "2. Contenido actual del portapapeles (TARGETS):"
xclip -selection clipboard -t TARGETS -o 2>&1
echo ""

# 3. Intentar capturar imagen
echo "3. Probando captura de imagen..."
TEST_DIR="/tmp/nvim-clipboard-test"
mkdir -p "$TEST_DIR"
PNG_FILE="$TEST_DIR/test.png"
WEBP_FILE="$TEST_DIR/test.webp"

# Limpiar archivos previos
rm -f "$PNG_FILE" "$WEBP_FILE"

# Intentar capturar con diferentes formatos
echo "   a) Intentando image/png..."
xclip -selection clipboard -t image/png -o > "$PNG_FILE" 2>&1
if [ -f "$PNG_FILE" ] && [ -s "$PNG_FILE" ]; then
    SIZE=$(stat -f%z "$PNG_FILE" 2>/dev/null || stat -c%s "$PNG_FILE" 2>/dev/null)
    echo "      ✓ Capturado: $SIZE bytes"
    file "$PNG_FILE"
else
    echo "      ✗ No se pudo capturar con image/png"
    rm -f "$PNG_FILE"
    
    echo "   b) Intentando image/x-png..."
    xclip -selection clipboard -t image/x-png -o > "$PNG_FILE" 2>&1
    if [ -f "$PNG_FILE" ] && [ -s "$PNG_FILE" ]; then
        SIZE=$(stat -f%z "$PNG_FILE" 2>/dev/null || stat -c%s "$PNG_FILE" 2>/dev/null)
        echo "      ✓ Capturado: $SIZE bytes"
        file "$PNG_FILE"
    else
        echo "      ✗ No se pudo capturar con image/x-png"
        rm -f "$PNG_FILE"
        
        echo "   c) Intentando PNG (mayúsculas)..."
        xclip -selection clipboard -t PNG -o > "$PNG_FILE" 2>&1
        if [ -f "$PNG_FILE" ] && [ -s "$PNG_FILE" ]; then
            SIZE=$(stat -f%z "$PNG_FILE" 2>/dev/null || stat -c%s "$PNG_FILE" 2>/dev/null)
            echo "      ✓ Capturado: $SIZE bytes"
            file "$PNG_FILE"
        else
            echo "      ✗ FALLO: No hay imagen válida en el portapapeles"
        fi
    fi
fi
echo ""

# 4. Convertir a WebP si se capturó
if [ -f "$PNG_FILE" ] && [ -s "$PNG_FILE" ]; then
    echo "4. Convirtiendo a WebP..."
    cwebp -q 80 "$PNG_FILE" -o "$WEBP_FILE" 2>&1
    
    if [ -f "$WEBP_FILE" ] && [ -s "$WEBP_FILE" ]; then
        WEBP_SIZE=$(stat -f%z "$WEBP_FILE" 2>/dev/null || stat -c%s "$WEBP_FILE" 2>/dev/null)
        echo "   ✓ WebP creado: $WEBP_SIZE bytes"
        file "$WEBP_FILE"
        echo ""
        echo "✅ PROCESO COMPLETO EXITOSO"
    else
        echo "   ✗ Error en conversión a WebP"
        echo ""
        echo "❌ FALLO EN CONVERSIÓN"
    fi
else
    echo "4. No se puede convertir - no hay PNG válido"
    echo ""
    echo "❌ NO HAY IMAGEN EN PORTAPAPELES"
fi
echo ""

# Limpiar
echo "Archivos de prueba en: $TEST_DIR"
ls -lh "$TEST_DIR" 2>/dev/null
