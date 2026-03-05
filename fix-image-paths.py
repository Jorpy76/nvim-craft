#!/usr/bin/env python3
"""
Script para corregir rutas de imágenes en archivos Markdown de Obsidian.
Busca imágenes con solo el nombre (sin ruta) y las convierte a rutas relativas.
"""

import os
import re
from pathlib import Path

# Configuración
VAULT_ROOT = Path("/home/jorgerios/obsidian-vault")
IMAGES_DIR = VAULT_ROOT / "HELPERS/Images"

# Patrón para encontrar imágenes con solo nombre (sin / en la ruta)
IMAGE_PATTERN = re.compile(r'!\[([^\]]*)\]\(([^/)]+\.(webp|png|jpg|jpeg|gif))\)')

def calculate_relative_path(markdown_file: Path, image_name: str) -> str:
    """Calcula la ruta relativa desde el archivo markdown hasta la imagen."""
    image_path = IMAGES_DIR / image_name
    
    # Si la imagen no existe, la retornamos sin cambios
    if not image_path.exists():
        return image_name
    
    # Calculamos la ruta relativa
    md_dir = markdown_file.parent
    try:
        rel_path = os.path.relpath(image_path, md_dir)
        return rel_path
    except ValueError:
        # En caso de error, retornamos el original
        return image_name

def fix_markdown_file(file_path: Path, dry_run=True):
    """Corrige las rutas de imágenes en un archivo markdown."""
    content = file_path.read_text(encoding='utf-8')
    original_content = content
    
    changes = []
    
    def replace_image(match):
        alt_text = match.group(1)
        image_name = match.group(2)
        
        # Calculamos la nueva ruta relativa
        new_path = calculate_relative_path(file_path, image_name)
        
        if new_path != image_name:
            old = f"![{alt_text}]({image_name})"
            new = f"![{alt_text}]({new_path})"
            changes.append((old, new))
            return new
        
        return match.group(0)
    
    # Reemplazamos todas las coincidencias
    content = IMAGE_PATTERN.sub(replace_image, content)
    
    # Mostramos los cambios
    if changes:
        rel_path = file_path.relative_to(VAULT_ROOT)
        print(f"\n📝 {rel_path}")
        for old, new in changes:
            print(f"  ❌ {old}")
            print(f"  ✅ {new}")
        
        # Si no es dry-run, guardamos el archivo
        if not dry_run:
            file_path.write_text(content, encoding='utf-8')
            print(f"  💾 Guardado")
        
        return len(changes)
    
    return 0

def main():
    print("🔍 Buscando archivos markdown con imágenes...\n")
    
    # Primera pasada: dry-run (solo mostrar cambios)
    total_changes = 0
    files_to_fix = []
    
    for md_file in VAULT_ROOT.rglob("*.md"):
        changes = fix_markdown_file(md_file, dry_run=True)
        if changes > 0:
            total_changes += changes
            files_to_fix.append(md_file)
    
    if total_changes == 0:
        print("✨ No se encontraron imágenes para corregir.")
        return
    
    print(f"\n📊 Total: {total_changes} imágenes en {len(files_to_fix)} archivos")
    print("\n¿Deseas aplicar estos cambios? (s/n): ", end='')
    
    response = input().strip().lower()
    
    if response == 's':
        print("\n🔧 Aplicando cambios...\n")
        for md_file in files_to_fix:
            fix_markdown_file(md_file, dry_run=False)
        print(f"\n✅ Completado! {total_changes} imágenes corregidas.")
    else:
        print("\n❌ Operación cancelada. No se realizaron cambios.")

if __name__ == "__main__":
    main()
