#!/bin/bash

# Variables
SOURCE_DIR="/app/Datos"
BACKUP_DIR="/app/Backup-datos"
LOG_FILE="/app/backup.log"
SNAPSHOT_FILE="/app/.snapshot_anterior.txt"
MAX_BACKUPS=5
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")

# Crear carpeta de backup si no existe
mkdir -p "$BACKUP_DIR"

# Crear snapshot actual
find "$SOURCE_DIR" -printf "%P%y\n" | sed 's/d$/\//' | sort > /app/.snapshot_actual.txt

CAMBIOS=""
BACKUP_NAME="Backup-$TIMESTAMP"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME.tar.gz"

# === INICIO LOG ===
{
    echo "--------------------------------------"
    echo "📦 Backup iniciado: $TIMESTAMP"
    echo "📂 Origen: $SOURCE_DIR"
    echo "📁 Destino: $BACKUP_PATH"
} >> "$LOG_FILE"

# Crear backup
tar -czf "$BACKUP_PATH" -C "$SOURCE_DIR" .
RESULTADO=$?

# Eliminar backups antiguos
TOTAL=$(ls -1t "$BACKUP_DIR"/Backup-*.tar.gz 2>/dev/null | wc -l)
if [ "$TOTAL" -gt "$MAX_BACKUPS" ]; then
    ELIMINAR=$(ls -1t "$BACKUP_DIR"/Backup-*.tar.gz | tail -n +$((MAX_BACKUPS+1)))
    for archivo in $ELIMINAR; do
        echo "🧹 Versión antigua eliminada: $archivo" >> "$LOG_FILE"
        rm "$archivo"
    done
fi

# Comparar snapshots
if [ -f "$SNAPSHOT_FILE" ]; then
    # Carpetas creadas
    CARPETAS_CREADAS=$(comm -13 "$SNAPSHOT_FILE" /app/.snapshot_actual.txt | grep '/$')
    [ -n "$CARPETAS_CREADAS" ] && {
        CAMBIOS+="📁 Carpetas creadas en $SOURCE_DIR:\n"
        CAMBIOS+=$(echo "$CARPETAS_CREADAS" | sed 's/^/Carpeta creada: /')
        CAMBIOS+="\n"
    }

    # Carpetas eliminadas
    CARPETAS_ELIMINADAS=$(comm -23 "$SNAPSHOT_FILE" /app/.snapshot_actual.txt | grep '/$')
    [ -n "$CARPETAS_ELIMINADAS" ] && {
        CAMBIOS+="🗑️ Carpetas eliminadas:\n"
        CAMBIOS+=$(echo "$CARPETAS_ELIMINADAS" | sed 's/^/Carpeta eliminada: /')
        CAMBIOS+="\n"
    }

    # Archivos creados
    ARCHIVOS_CREADOS=$(comm -13 "$SNAPSHOT_FILE" /app/.snapshot_actual.txt | grep -v '/$')
    [ -n "$ARCHIVOS_CREADOS" ] && {
        CAMBIOS+="📄 Archivos creados o modificados:\n"
        CAMBIOS+=$(echo "$ARCHIVOS_CREADOS" | sed 's/^/Archivo creado: /')
        CAMBIOS+="\n"
    }

    # Archivos eliminados
    ARCHIVOS_ELIMINADOS=$(comm -23 "$SNAPSHOT_FILE" /app/.snapshot_actual.txt | grep -v '/$')
    [ -n "$ARCHIVOS_ELIMINADOS" ] && {
        CAMBIOS+="🗑️ Archivos eliminados:\n"
        CAMBIOS+=$(echo "$ARCHIVOS_ELIMINADOS" | sed 's/^/Archivo eliminado: /')
        CAMBIOS+="\n"
    }

    # Si hubo cambios, registrarlos
    if [ -n "$CAMBIOS" ]; then
        echo -e "\n🕒 $TIMESTAMP - Cambios detectados desde el último backup:" >> "$LOG_FILE"
        echo -e "$CAMBIOS" >> "$LOG_FILE"
    fi
else
    echo "📌 Primera ejecución. No hay snapshot anterior para comparar." >> "$LOG_FILE"
fi

# Guardar snapshot actual
mv /app/.snapshot_actual.txt "$SNAPSHOT_FILE"

# Escribir estado final del backup
if [ $RESULTADO -eq 0 ]; then
    echo "✅ Backup creado correctamente." >> "$LOG_FILE"
else
    echo "❌ Error al crear el backup." >> "$LOG_FILE"
    ERROR_MSG=$(tail -n 1 "$LOG_FILE")
    FULL_PATH="$(realpath $0)"
    python3 /app/send_error_email.py "ERROR EN EL BACKUP DIARIO" "El backup falló con el error: $ERROR_MSG\nRuta del script: $FULL_PATH"
fi
