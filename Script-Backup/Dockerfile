# Usar una imagen base oficial de Python
FROM python:3.9-slim

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y cron rsyslog

# Establecer el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos de la aplicación
COPY . .

# Instalar dependencias de Python
RUN pip install -r requirements.txt

# Configurar cron job para respaldos cada 2 horas
RUN echo "0 */2 * * * /app/Script-Backup/backup.sh >> /app/Script-Backup/cron.log 2>&1" > /etc/cron.d/backup-cron

# Configurar cron job para enviar el resumen diario a las 23:59
RUN echo "59 23 * * * python3 /app/Script-Backup/send_daily_summary.py >> /app/Script-Backup/cron.log 2>&1" >> /etc/cron.d/backup-cron

RUN chmod 0644 /etc/cron.d/backup-cron
RUN crontab /etc/cron.d/backup-cron

# Ejecutar cron en el contenedor
CMD ["cron", "-f"]
