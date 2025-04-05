#!/bin/bash

# Variables
DOWNLOADS_DIR="/usr/local/bin/downloads"
TMP_DIR="/usr/local/bin/tmp"
LOG_FILE="/usr/local/bin/limpieza.log"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
MAX_DAYS=2
MAX_SIZE_MB=100
THRESHOLD_SIZE=$((MAX_SIZE_MB * 1024 * 1024)) # Convertir a bytes

CHANGES=""

# Encabezado del log
{
echo "--------------------------------------"
echo "🧹 Limpieza iniciada: $TIMESTAMP"
echo "📂 Directorios objetivo:"
echo "   - $DOWNLOADS_DIR"
echo "   - $TMP_DIR"
echo "📁 Criterios:"
echo "   - Archivos de más de $MAX_DAYS días"
echo "   - Archivos mayores a $MAX_SIZE_MB MB"
} >> "$LOG_FILE"

# Función para registrar eliminaciones
log_deleted() {
    local tipo=$1
    local archivo=$2
    CHANGES+="$tipo eliminado: ${archivo/#\/usr\/local\/bin\//}\n"
}

# Buscar y eliminar archivos antiguos
for DIR in "$DOWNLOADS_DIR" "$TMP_DIR"; do
    while IFS= read -r archivo; do
        rm -f "$archivo"
        log_deleted "Archivo" "$archivo"
    done < <(find "$DIR" -type f -mtime +$MAX_DAYS)
done

# Buscar y eliminar archivos grandes
for DIR in "$DOWNLOADS_DIR" "$TMP_DIR"; do
    while IFS= read -r archivo; do
        rm -f "$archivo"
        log_deleted "Archivo" "$archivo"
    done < <(find "$DIR" -type f -size +${THRESHOLD_SIZE}c)
done

# Resultado
if [ $? -eq 0 ]; then
    echo "✅ Limpieza completada correctamente." >> "$LOG_FILE"
else
    echo "❌ Error durante la limpieza" >> "$LOG_FILE"
fi

# Si hubo cambios, los mostramos
if [ -n "$CHANGES" ]; then
    {
        echo ""
        echo "🕒 $TIMESTAMP - Cambios detectados:"
        echo -e "🗑️ $CHANGES"
    } >> "$LOG_FILE"
fi

# Enviar correo con resumen del log
python3 /usr/local/bin/send_daily_summary.py "Resumen diario de limpieza" "$LOG_FILE"
