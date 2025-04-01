# Usar una imagen base adecuada
FROM python:3.9-slim

# Establecer el directorio de trabajo
WORKDIR /usr/local/bin

# Copiar los archivos necesarios
COPY clean_up.sh .
COPY send_daily_summary.py .
COPY send_error_email.py .
COPY requirements.txt .

# Instalar las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Dar permisos de ejecución al script de limpieza
RUN chmod +x clean_up.sh

# Instalar cron
RUN apt-get update && apt-get install -y cron

# Copiar el archivo crontab y aplicarlo
COPY crontab.txt /etc/cron.d/clean_up_cron
RUN chmod 0644 /etc/cron.d/clean_up_cron
RUN crontab /etc/cron.d/clean_up_cron

# Crear el archivo de log si no existe
RUN touch /var/log/script-limpieza.log

# Iniciar cron y luego mantener el contenedor en ejecución
CMD cron && tail -f /var/log/script-limpieza.log
