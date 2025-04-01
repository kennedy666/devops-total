#!/bin/bash

# Variables
SOURCE_DIR="/app/Script-Backup/Datos"
BACKUP_DIR="/app/Script-Backup/Backup-datos"
LOG_FILE="/app/Script-Backup/backup.log"
MAX_BACKUPS=5

# Crear carpeta de backup si no existe
mkdir -p $BACKUP_DIR

# Crear un nuevo backup
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
BACKUP_NAME="Backup-$TIMESTAMP"
tar -czf $BACKUP_DIR/$BACKUP_NAME.tar.gz -C $SOURCE_DIR .

# Guardar el log de la ejecución
echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup creado: $BACKUP_NAME" >> $LOG_FILE

# Eliminar backups antiguos si exceden el máximo permitido
BACKUPS=$(ls -1 $BACKUP_DIR | wc -l)
if [ $BACKUPS -gt $MAX_BACKUPS ]; then
    OLDEST_BACKUP=$(ls -1 $BACKUP_DIR | head -n 1)
    rm -f $BACKUP_DIR/$OLDEST_BACKUP
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup eliminado: $OLDEST_BACKUP" >> $LOG_FILE
fi

# Enviar correo en caso de error
if [ $? -ne 0 ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Error en el backup" >> $LOG_FILE
    python3 /app/Script-Backup/send_error_email.py "Error en el backup" "El backup ha fallado en $TIMESTAMP"
fi
