import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication
from dotenv import load_dotenv
import os
from datetime import datetime

# Cargar variables de entorno
load_dotenv("/usr/local/bin/.env")

MAIL_ADDRESS = os.getenv('MAIL_ADDRESS')
EMAIL_PASSWORD = os.getenv('EMAIL_PASSWORD')
TO_EMAIL = os.getenv('TO_EMAIL')

# Ruta del log
log_path = "/usr/local/bin/limpieza.log"
log_filename = "limpieza.log"

# Crear el mensaje
msg = MIMEMultipart()
msg['From'] = MAIL_ADDRESS
msg['To'] = TO_EMAIL
msg['Subject'] = "Resumen limpieza diaria"

# Cuerpo del correo
timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
body = f"""✅ Limpieza diaria completada con éxito.
🕒 Fecha: {timestamp}
📎 Se adjunta el archivo limpieza.log con los detalles."""

msg.attach(MIMEText(body, 'plain'))

# Adjuntar log
with open(log_path, 'rb') as f:
    part = MIMEApplication(f.read(), Name=log_filename)
    part['Content-Disposition'] = f'attachment; filename="{log_filename}"'
    msg.attach(part)

# Enviar el correo
try:
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login(MAIL_ADDRESS, EMAIL_PASSWORD)
        server.sendmail(MAIL_ADDRESS, TO_EMAIL, msg.as_string())
    print("✅ Correo con log enviado exitosamente")
except Exception as e:
    print(f"❌ Error al enviar correo: {e}")
