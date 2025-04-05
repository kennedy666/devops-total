#!/bin/bash

LOG_FILE="/usr/local/bin/estado.log"
LIMIT=60
DATE=$(date +"%Y-%m-%d %H:%M:%S")
EMAIL_SCRIPT="/usr/local/bin/send_alert_email.py"

# Borrar log anterior
> $LOG_FILE
echo "📅 Registro del sistema - $DATE" >> $LOG_FILE
echo "--------------------------------------" >> $LOG_FILE

# CPU
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "🧠 CPU: ${CPU_USAGE}% usado" >> $LOG_FILE

# RAM
MEM_USAGE=$(free | awk '/Mem:/ {printf("%.2f"), $3/$2 * 100}')
echo "💾 RAM: ${MEM_USAGE}% usado" >> $LOG_FILE

# DISCO
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
echo "📀 Disco raíz: ${DISK_USAGE}% usado" >> $LOG_FILE

# GPU (si existe)
if command -v nvidia-smi &> /dev/null; then
    GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)
    echo "🎮 GPU: ${GPU_USAGE}% usado" >> $LOG_FILE
else
    echo "🎮 GPU: no disponible" >> $LOG_FILE
    GPU_USAGE=0
fi

# Comprobar alertas
if (( $(echo "$CPU_USAGE > $LIMIT" | bc -l) )) || \
   (( $(echo "$MEM_USAGE > $LIMIT" | bc -l) )) || \
   (( $(echo "$DISK_USAGE > $LIMIT" | bc -l) )) || \
   (( $(echo "$GPU_USAGE > $LIMIT" | bc -l) )); then
    python3 "$EMAIL_SCRIPT" "⚠️ Alerta: Recursos superan el 60%" "$LOG_FILE"
fi
