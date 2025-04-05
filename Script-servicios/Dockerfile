# Imagen base
FROM debian:bullseye-slim

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    cron systemctl procps \
    && apt-get clean

# Directorio de trabajo
WORKDIR /usr/local/bin

# Copiar archivos
COPY verificar_servicios.sh .
COPY send_alert_email.py .
COPY requirements.txt .

# Instalar dependencias Python
RUN pip3 install -r requirements.txt

# Permisos
RUN chmod +x verificar_servicios.sh

# Crear carpeta de logs
RUN mkdir -p /usr/local/bin/logs && touch /usr/local/bin/logs/servicios.log

# Configurar cron
RUN echo "*/10 * * * * /usr/local/bin/verificar_servicios.sh >> /usr/local/bin/logs/servicios.log 2>&1" > /etc/cron.d/verificar_servicios_cron

RUN chmod 0644 /etc/cron.d/verificar_servicios_cron
RUN crontab /etc/cron.d/verificar_servicios_cron

# Iniciar cron
CMD ["cron", "-f"]
