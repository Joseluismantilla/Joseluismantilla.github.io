#!/usr/bin/env bash

# Versión esperada (Objetivo superior, ej: 2.2-2)
VERSION="2.2-2"  

# 1. Obtener la versión completa del RPM instalado (ej: rhsa-2.2-1.el10)
if ! rpm_out=$(rpm -q rhsa 2>/dev/null); then
    echo "[ERROR] El paquete rhsa no está instalado."
    exit 1
fi

# Extraer de forma exacta el formato Version-Release (ej: 2.2-1)
CURRENT_VERSION=$(echo "$rpm_out" | sed -E 's/rhsa-([^.]+).*/\1/')

# Ruta del archivo de configuración
COURSE_FILE="/usr/share/rhsa/course"

# ==========================================
# Lógica de Validación Condicional (sort -V)
# ==========================================

# Explicación de 'sort -V': Ordena cadenas de texto que contienen números de versión de forma natural.
# Si al poner ambas versiones en una lista y ordenarlas, la versión más alta queda abajo,
# podemos determinar con certeza matemática si el sistema está al día o desactualizado.

VERSION_MAS_ALTA=$(printf '%s\n%s' "$CURRENT_VERSION" "$VERSION" | sort -V | tail -n1)

if [[ "$CURRENT_VERSION" == "$VERSION" ]]; then
    # Caso 1: Las versiones coinciden exactamente (2.2-2 == 2.2-2)
    echo "Course updated, there is no any pending update"

elif [[ "$VERSION_MAS_ALTA" == "$CURRENT_VERSION" ]]; then
    # Caso 2: La versión del sistema es MAYOR que la esperada (ej: el alumno tiene un paquete de prueba 2.2-3)
    echo "Your current version ($CURRENT_VERSION) is newer than the target version ($VERSION). No update needed."

else
    # Caso 3: La versión del sistema es MENOR (ej: 2.2-1 < 2.2-2). PROCEDE A ACTUALIZAR.
    if [[ -f "$COURSE_FILE" ]]; then
        
        # Validamos activación ignorando mayúsculas/minúsculas
        if grep -iqw "enabled" "$COURSE_FILE"; then
            echo "[INFO] New update available ($CURRENT_VERSION -> $VERSION). Course is enabled. Proceeding with the update process..."
            # Aquí se invocaría el update.sh
        else
            echo "You should activate the course first before proceed."
            exit 0
        fi
    else
        echo "[ERROR] The course or file $COURSE_FILE doesn't exist."
    fi
fi