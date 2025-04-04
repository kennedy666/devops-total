# Usar una imagen base oficial de Python
FROM python:3.9-slim

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y cron rsyslog

# Establecer el directorio de trabajo en el contenedor
WORKDIR /usr/local/bin

# Copiar los archivos de la aplicación
COPY clean_up.sh .
COPY send_daily_summary.py .
COPY send_error_email.py .
COPY requirements.txt .

# Instalar dependencias de Python
RUN pip install -r requirements.txt

# Dar permisos de ejecución al script de limpieza
RUN chmod +x clean_up.sh

# Configurar cron job para limpiar diariamente a medianoche
RUN echo "0 0 * * * /usr/local/bin/clean_up.sh >> /var/log/script-limpieza.log 2>&1" > /etc/cron.d/clean_up_cron

# Configurar cron job para enviar el resumen diario a las 23:59
RUN echo "59 23 * * * python3 /usr/local/bin/send_daily_summary.py 'Daily Summary' 'This is the body of the email.' >> /var/log/script-limpieza.log 2>&1" >> /etc/cron.d/clean_up_cron

RUN chmod 0644 /etc/cron.d/clean_up_cron
RUN crontab /etc/cron.d/clean_up_cron

# Crear el archivo de log si no existe
RUN touch /var/log/script-limpieza.log && chmod 666 /var/log/script-limpieza.log

# Ejecutar cron en el contenedor
CMD ["cron", "-f"]
