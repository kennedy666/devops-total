#!/bin/bash

# Variables
DOWNLOADS_DIR="/path/to/Downloads"
TMP_DIR="/path/to/tmp"
LOG_FILE="/var/log/script-limpieza.log"
MAX_DAYS=2
MAX_SIZE=100
THRESHOLD_SIZE=$((MAX_SIZE * 1024 * 1024)) # Convertir MB a bytes

# Función para enviar correos electrónicos
send_email() {
    local subject=$1
    local body=$2
    python3 /usr/local/bin/send_daily_summary.py "$subject" "$body"
}

# Limpiar archivos antiguos
find $DOWNLOADS_DIR -type f -mtime +$MAX_DAYS -exec rm -f {} \;
find $TMP_DIR -type f -mtime +$MAX_DAYS -exec rm -f {} \;

# Limpiar archivos grandes
find $DOWNLOADS_DIR -type f -size +${THRESHOLD_SIZE}c -exec rm -f {} \;
find $TMP_DIR -type f -size +${THRESHOLD_SIZE}c -exec rm -f {} \;

# Verificar éxito de la limpieza
if [ $? -eq 0 ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Limpieza completada exitosamente" >> $LOG_FILE
    send_email "Limpieza diaria completada" "La limpieza diaria se ha completado exitosamente a las $(date +"%Y-%m-%d %H:%M:%S")."
else
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Error en la limpieza" >> $LOG_FILE
    send_email "Error en la limpieza diaria" "Hubo un error durante la limpieza diaria a las $(date +"%Y-%m-%d %H:%M:%S")."
fi
