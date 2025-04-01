import smtplib
from email.mime.text import MIMEText
from dotenv import load_dotenv
import os

# Cargar variables de entorno
load_dotenv("/usr/local/bin/.env")

SMTP_SERVER = os.getenv('SMTP_SERVER')
SMTP_PORT = os.getenv('SMTP_PORT')
SMTP_USERNAME = os.getenv('SMTP_USERNAME')
SMTP_PASSWORD = os.getenv('SMTP_PASSWORD')
EMAIL_FROM = os.getenv('EMAIL_FROM')
EMAIL_TO = os.getenv('EMAIL_TO')

# Configuración del correo
def send_email(subject, body, to_email):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = EMAIL_FROM
    msg['To'] = to_email

    try:
        with smtplib.SMTP(SMTP_SERVER, SMTP_PORT) as server:
            server.starttls()
            server.login(SMTP_USERNAME, SMTP_PASSWORD)
            server.sendmail(EMAIL_FROM, to_email, msg.as_string())
        print("Correo enviado exitosamente")
    except Exception as e:
        print(f"Error al enviar correo: {e}")

# Contenido del correo
subject = "Error en el script de limpieza"
body = "Se ha producido un error al ejecutar el script de limpieza. Revisa el log para más detalles."

# Enviar el correo
send_email(subject, body, EMAIL_TO)
