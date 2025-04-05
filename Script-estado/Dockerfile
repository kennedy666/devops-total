# === BASE ===
FROM debian:bullseye-slim

# === INSTALAR DEPENDENCIAS ===
RUN apt-get update && apt-get install -y \
    cron \
    procps \
    bc \
    python3 \
    python3-pip

# === DIRECTORIO DE TRABAJO ===
WORKDIR /usr/local/bin

# === COPIAR ARCHIVOS ===
COPY estado_sistema.sh ./estado_sistema.sh
COPY send_alert_email.py ./send_alert_email.py
COPY requirements.txt ./requirements.txt

# === INSTALAR LIBRERÍAS PYTHON ===
RUN pip3 install -r requirements.txt

# === PERMISOS DE EJECUCIÓN ===
RUN chmod +x estado_sistema.sh

# === CRON: cada 10 minutos ===
RUN echo "*/10 * * * * bash /usr/local/bin/estado_sistema.sh >> /usr/local/bin/estado.log 2>&1" > /etc/cron.d/estado_cron
RUN chmod 0644 /etc/cron.d/estado_cron
RUN crontab /etc/cron.d/estado_cron

# === LOG DEL SISTEMA ===
RUN touch /usr/local/bin/estado.log

# === COMANDO POR DEFECTO ===
CMD ["cron", "-f"]
