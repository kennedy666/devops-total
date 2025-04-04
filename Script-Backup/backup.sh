#!/bin/bash

# === Variables ===
SOURCE_DIR="/app/Script-Backup/Datos"
BACKUP_DIR="/app/Script-Backup/Backup-datos"
LOG_FILE="/app/Script-Backup/backup.log"
MAX_BACKUPS=5
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
BACKUP_NAME="Backup-$TIMESTAMP.tar.gz"
ENV_FILE="/app/Script-Backup/.env"

# === Crear directorio si no existe ===
mkdir -p "$BACKUP_DIR"

# === Crear backup ===
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" .
STATUS=$?

# === Guardar log ===
if [ $STATUS -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Backup creado: $BACKUP_NAME" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ Error en el backup: $BACKUP_NAME" >> "$LOG_FILE"
    python3 /app/Script-Backup/send_error_email.py "Error en el backup" "El backup ha fallado en $TIMESTAMP"
fi

# === Mantener solo los últimos 5 backups ===
BACKUP_COUNT=$(ls -1t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    OLDEST=$(ls -1t "$BACKUP_DIR"/*.tar.gz | tail -n +$((MAX_BACKUPS + 1)))
    for file in $OLDEST; do
        rm -f "$file"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 🗑️ Backup eliminado: $(basename "$file")" >> "$LOG_FILE"
    done
fi
