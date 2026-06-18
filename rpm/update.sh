#!/usr/bin/env bash

# Versión esperada (Objetivo superior, ej: 2.2-1)
VERSION="2.2-1" # Version del nuevo RPM para el curso  

# 1. Obtener la versión completa del RPM instalado (ej: rhsa-2.2-1.el10)
if ! rpm_out=$(rpm -q rhsa 2>/dev/null); then
    echo "[ERROR] El paquete rhsa no está instalado."
    exit 1
fi

# CORRECCIÓN ULTRA ESTRICTA: Extrae exactamente el patrón X.Y-Z aislando los caracteres de Red Hat (.el10)
CURRENT_VERSION=$(echo "$rpm_out" | sed -E 's/rhsa-([0-9]+\.[0-9]+-[0-9]+).*/\1/')

# Ruta del archivo de configuración
COURSE_FILE="/usr/share/rhsa/course"

# ==========================================
# Lógica de Validación Condicional (sort -V)
# ==========================================

# Eliminar espacios invisibles por seguridad antes de comparar
CURRENT_VERSION=$(echo "$CURRENT_VERSION" | xargs)
VERSION=$(echo "$VERSION" | xargs)

if [[ "$CURRENT_VERSION" == "$VERSION" ]]; then
    # Caso 1: Las versiones coinciden exactamente (2.2-1 == 2.2-1)
    echo "Course updated, there is no any pending update"

else
    # Si no son exactamente iguales, evaluamos cuál es la mayor usando sort -V
    VERSION_MAS_ALTA=$(printf '%s\n%s' "$CURRENT_VERSION" "$VERSION" | sort -V | tail -n1)

    if [[ "$VERSION_MAS_ALTA" == "$CURRENT_VERSION" ]]; then
        # Caso 2: La versión del sistema es MAYOR que la esperada (ej: 2.2-2 > 2.2-1)
        echo "Your current version ($CURRENT_VERSION) is newer than the target version ($VERSION). No update needed."

    else
        # Caso 3: La versión del sistema es estrictamente MENOR (ej: 2.2-1 < 2.2-2). PROCEDE A ACTUALIZAR.
        if [[ -f "$COURSE_FILE" ]]; then
            
            # CORRECCIÓN ANSI: grep -iq (sin -w) para que ignore los códigos de color de escape de la terminal
            if grep -iq "enabled" "$COURSE_FILE"; then
                echo "[INFO] New update available ($CURRENT_VERSION -> $VERSION). Course is enabled..."
                # Aquí iría tu script de actualización (ej: ./update.sh)
            else
                echo "You should activate the course first before proceed."
            fi
        else
            echo "[ERROR] The course or file $COURSE_FILE doesn't exist."
        fi
    fi
fi