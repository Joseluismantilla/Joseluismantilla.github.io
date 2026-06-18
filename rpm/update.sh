#!/usr/bin/env bash

# Versión esperada (Objetivo superior, ej: 2.2-1)
VERSION="2.2-1" 

# Control de validación de activación
VALIDATE_COURSE_ENABLED=true

# Control de parches: Si está en true, ejecuta comandos específicos e ignora versiones
INSTALL_PATCH=false

# Ruta del archivo de configuración
COURSE_FILE="/usr/share/rhsa/course"

# ==========================================
# 1. Validación de Activación Inicial (Si está habilitada)
# ==========================================
if [ "$VALIDATE_COURSE_ENABLED" = true ]; then
    if [[ -f "$COURSE_FILE" ]]; then
        # Buscamos de forma flexible "enabled" (omitiendo códigos de color ANSI)
        if ! grep -iq "enabled" "$COURSE_FILE"; then
            echo "You should activate the course first before proceed."
            exit 1
        fi
    else
        echo "[ERROR] The course file $COURSE_FILE doesn't exist. Please activate the course."
        exit 1
    fi
fi

# ==========================================
# 2. Lógica de Parche (INSTALL_PATCH=true)
# ==========================================
if [ "$INSTALL_PATCH" = true ]; then
    echo "[INFO] INSTALL_PATCH está habilitado. Ejecutando comandos de parche independientes de la versión..."
    
    # -------------------------------------------------------------
    # COLOCA AQUÍ TUS COMANDOS DE PARCHE
    # Ejemplo:
    # ./patch_labs.sh
    # -------------------------------------------------------------
    
    echo "Patch applied successfully."
    exit 0 # Terminamos el script con éxito sin validar versiones
fi

# ==========================================
# 3. Extracción de Versión RPM
# ==========================================
if ! rpm_out=$(rpm -q rhsa 2>/dev/null); then
    echo "[ERROR] El paquete rhsa no está instalado."
    exit 1
fi

# Extrae exactamente el patrón X.Y-Z aislando los caracteres .el10
CURRENT_VERSION=$(echo "$rpm_out" | sed -E 's/rhsa-([0-9]+\.[0-9]+-[0-9]+).*/\1/')

# Limpiar espacios invisibles
CURRENT_VERSION=$(echo "$CURRENT_VERSION" | xargs)
VERSION=$(echo "$VERSION" | xargs)


# ==========================================
# 4. Lógica de Control de Versiones (sort -V)
# ==========================================
if [[ "$CURRENT_VERSION" == "$VERSION" ]]; then
    # Caso 1: Las versiones coinciden exactamente
    echo "Course updated, there is no any pending update"

else
    # Si no son iguales, evaluamos cuál es la mayor
    VERSION_MAS_ALTA=$(printf '%s\n%s' "$CURRENT_VERSION" "$VERSION" | sort -V | tail -n1)

    if [[ "$VERSION_MAS_ALTA" == "$CURRENT_VERSION" ]]; then
        # Caso 2: El alumno tiene una versión más nueva que el spec
        echo "Your current version ($CURRENT_VERSION) is newer than the target version ($VERSION). No update needed."
    else
        # Caso 3: La versión instalada es menor (ej: 2.2-1 < 2.2-2). 
        echo "[INFO] New update available ($CURRENT_VERSION -> $VERSION). Proceeding with the update process..."
        # Aquí invocas tu lógica de actualización regular o script update.sh
    fi
fi