FROM python:3.10-slim

# Instalar herramientas necesarias
RUN apt-get update && apt-get install -y cron && apt-get clean

# Crear directorios
WORKDIR /app

# Copiar archivos
COPY . /app/Script-Backup

# Permisos
RUN chmod +x /app/Script-Backup/backup.sh

# Crear tarea en cron (cada 10 minutos)
RUN echo "*/10 * * * * bash /app/Script-Backup/backup.sh >> /app/Script-Backup/cron.log 2>&1" > /etc/cron.d/backup-cron \
    && chmod 0644 /etc/cron.d/backup-cron \
    && crontab /etc/cron.d/backup-cron

# Ejecutar cron en primer plano
CMD ["cron", "-f"]
