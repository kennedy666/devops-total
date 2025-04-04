import smtplib
from email.mime.text import MIMEText
from dotenv import load_dotenv
import os
import sys

# Cargar variables de entorno
load_dotenv("/usr/local/bin/.env")

MAIL_ADDRESS = os.getenv('MAIL_ADDRESS')
EMAIL_PASSWORD = os.getenv('EMAIL_PASSWORD')
TO_EMAIL = os.getenv('TO_EMAIL')

# Función para enviar correos electrónicos
def send_email(subject, body):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = MAIL_ADDRESS
    msg['To'] = TO_EMAIL

    try:
        with smtplib.SMTP('smtp.gmail.com', 587) as server
            server.starttls()
            server.login(MAIL_ADDRESS, EMAIL_PASSWORD)
            server.sendmail(MAIL_ADDRESS, TO_EMAIL, msg.as_string())
        print("Correo enviado exitosamente")
    except Exception as e:
        print(f"Error al enviar correo: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: send_daily_summary.py <subject> <body>")
        sys.exit(1)

    subject = sys.argv[1]
    body = sys.argv[2]
    send_email(subject, body)
