#!/bin/bash

# === VARIABLES ===
SERVICIOS=("cron" "ssh" "docker" "postgresql" "nginx" "apache2")
LOG_PATH="/usr/local/bin/logs/servicios.log"
FECHA=$(date +"%Y-%m-%d %H:%M:%S")
ESTADOS=()
HAY_CAIDOS=0

# === LIMPIAR LOG ANTERIOR ===
> "$LOG_PATH"

# === ENCABEZADO ===
echo "🕒 $FECHA - Comprobación de servicios:" >> "$LOG_PATH"

# === VERIFICAR CADA SERVICIO ===
for SERVICIO in "${SERVICIOS[@]}"; do
    if systemctl is-active --quiet "$SERVICIO"; then
        echo "✅ $SERVICIO está activo" >> "$LOG_PATH"
        ESTADOS+=("✅ $SERVICIO está activo")
    else
        echo "❌ $SERVICIO está caído" >> "$LOG_PATH"
        ESTADOS+=("❌ $SERVICIO está caído")
        HAY_CAIDOS=1
    fi
done

# === SEPARADOR DE LOG ===
echo "--------------------------------------" >> "$LOG_PATH"

# === ENVIAR CORREO SI HAY CAÍDOS ===
if [ "$HAY_CAIDOS" -eq 1 ]; then
    ASUNTO="🔴 ALERTA: Servicios caídos detectados"
    
    # Construir cuerpo con saltos de línea REALES
    CUERPO="🕒 $FECHA - Comprobación de servicios:"
    for LINEA in "${ESTADOS[@]}"; do
        CUERPO+="
$LINEA"
    done

    # Enviar email
    python3 /usr/local/bin/send_alert_email.py "$ASUNTO" "$CUERPO"
fi
