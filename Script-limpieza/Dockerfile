# === BASE ===
FROM python:3.9-slim

# === INSTALAR DEPENDENCIAS ===
RUN apt-get update && apt-get install -y cron rsyslog python3-pip

# === DIRECTORIO DE TRABAJO ===
WORKDIR /usr/local/bin

# === COPIAR SCRIPTS ===
COPY clean_up.sh .
COPY send_daily_summary.py .
COPY send_error_email.py .
COPY requirements.txt .

# === INSTALAR DEPENDENCIAS PYTHON ===
RUN pip install -r requirements.txt

# === PERMISOS DE EJECUCIÓN ===
RUN chmod +x clean_up.sh

# === CONFIGURAR CRON ===
RUN echo "0 19 * * * /usr/local/bin/clean_up.sh >> /usr/local/bin/limpieza.log 2>&1" > /etc/cron.d/clean_up_cron
RUN chmod 0644 /etc/cron.d/clean_up_cron
RUN crontab /etc/cron.d/clean_up_cron

# === ARCHIVO DE LOG ===
RUN touch /usr/local/bin/limpieza.log && chmod 666 /usr/local/bin/limpieza.log

# === COMANDO POR DEFECTO: INICIAR CRON ===
CMD ["cron", "-f"]
