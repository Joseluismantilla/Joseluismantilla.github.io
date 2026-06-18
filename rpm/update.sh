#!/usr/bin/env bash

# Versión esperada (referencia)
VERSION="2.1"  # Nota: Si el 'cut' corta hasta el segundo punto, dejará "2.1". Ajustamos aquí.

# 1. Obtener la versión actual cortada de forma segura
if ! rpm_out=$(rpm -q rhsa 2>/dev/null); then
    echo "[ERROR] El paquete rhsa no está instalado."
    exit 1
fi

CURRENT_VERSION=$(echo "$rpm_out" | cut -d. -f1-2)

# Ruta del archivo de configuración
COURSE_FILE="/usr/share/rhsa/course"

# ==========================================
# Lógica de Validación Condicional
# ==========================================

# Extraer solo la parte numérica de la versión para comparar (ej: rhsa-2.1 -> 2.1)
# O si prefieres comparar la cadena completa, asegúrate de que $VERSION incluya el prefijo "rhsa-"
CURRENT_NUMERIC=$(echo "$CURRENT_VERSION" | grep -oE '[0-9]+\.[0-9]+')

if [[ "$CURRENT_NUMERIC" == "$VERSION" ]]; then
    echo "Course updated, there is no any pending update"
else
    # El curso no está actualizado, procedemos a validar si está activo
    if [[ -f "$COURSE_FILE" ]]; then
        # Buscamos la palabra exacta "enabled" en el archivo
        if grep -qw "enabled" "$COURSE_FILE"; then
            echo "[INFO] Course is enabled. Proceeding with the update process..."
            # Aquí iría el código para proceder con la actualización
        else
            echo "You should activate the course first before proceed."
        fi
    else
        echo "[ERROR] The course or file $COURSE_FILE doesn't exist."
    fi
fi