#!/bin/bash

# Variables
SOURCE_DIR="/app/Datos"
BACKUP_DIR="/app/Backup-datos"
LOG_FILE="/app/backup.log"
MAX_BACKUPS=5
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

# Crear carpeta de backup si no existe
mkdir -p "$BACKUP_DIR"

# Crear backup
BACKUP_NAME="Backup-$TIMESTAMP"
{
    echo "📦 Backup iniciado: $TIMESTAMP"
    echo "📂 Origen: $SOURCE_DIR"
    echo "📁 Destino: $BACKUP_DIR/$BACKUP_NAME.tar.gz"
    
    tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" -C "$SOURCE_DIR" .
    
    echo "✅ Backup creado correctamente."
    echo "--------------------------------------"
    
    # Limpiar backups antiguos
    TOTAL=$(ls -1t "$BACKUP_DIR"/Backup-*.tar.gz 2>/dev/null | wc -l)
    if [ "$TOTAL" -gt "$MAX_BACKUPS" ]; then
        ELIMINAR=$(ls -1t "$BACKUP_DIR"/Backup-*.tar.gz | tail -n +$((MAX_BACKUPS+1)))
        for archivo in $ELIMINAR; do
            rm "$archivo"
            echo "🧹 Versión antigua eliminada (límite $MAX_BACKUPS): $archivo"
        done
    fi
} >> "$LOG_FILE" 2>&1

# Verificar si el backup tuvo éxito
if [ $? -ne 0 ]; then
    ERROR_MSG=$(tail -n 1 "$LOG_FILE")
    FULL_PATH="$(realpath $0)"
    python3 /app/send_error_email.py "ERROR EN EL BACKUP DIARIO" "El backup falló con el error: $ERROR_MSG\nRuta del script: $FULL_PATH"
fi
