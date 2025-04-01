#!/bin/bash

# Directorios a limpiar
DOWNLOADS_DIR="/path/to/Downloads"
TMP_DIR="/path/to/tmp"

# Log file
LOG_FILE="/path/to/Script-limpieza/clean_up.log"

# Fecha y hora actuales
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Función para limpiar archivos
clean_directory() {
  local dir=$1
  echo "Limpiando directorio: $dir" >> $LOG_FILE
  # Eliminar archivos de más de 1 día
  find $dir -type f -mtime +1 -exec rm -f {} \; >> $LOG_FILE 2>&1
  # Eliminar archivos mayores a 100MB
  find $dir -type f -size +100M -exec rm -f {} \; >> $LOG_FILE 2>&1
}

# Limpiar los directorios
echo "[$CURRENT_DATE] Iniciando limpieza" >> $LOG_FILE
clean_directory $DOWNLOADS_DIR
clean_directory $TMP_DIR
echo "[$CURRENT_DATE] Limpieza completada" >> $LOG_FILE

# Enviar correo con el reporte
mail -s "Reporte de limpieza" user@example.com < $LOG_FILE
