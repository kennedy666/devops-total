import os
import smtplib
from email.message import EmailMessage

# Variables de entorno
from_email = os.environ.get('MAIL_ADDRESS')
password = os.environ.get('EMAIL_PASSWORD')
to_email = os.environ.get('TO_EMAIL')

# Crear el mensaje
msg = EmailMessage()
msg['Subject'] = "Resumen diario"
msg['From'] = from_email
msg['To'] = to_email
msg.set_content("Este es el resumen de los backups del día de hoy, todo correcto.")

# Adjuntar backup.log
log_path = "/app/backup.log"
with open(log_path, 'rb') as f:
    log_content = f.read()
    msg.add_attachment(log_content, maintype='text', subtype='plain', filename='backup.log')

try:
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login(from_email, password)
        server.send_message(msg)
        print("✅ Correo de resumen diario enviado correctamente.")
except Exception as e:
    print("❌ Error al enviar el correo diario:", e)
