import smtplib
from email.mime.text import MIMEText
from dotenv import load_dotenv
import os

# Cargar variables de entorno
load_dotenv("/usr/local/bin/.env")

MAIL_ADDRESS = os.getenv("MAIL_ADDRESS")
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD")
TO_EMAIL = os.getenv("TO_EMAIL")

def send_email(subject, body):
    msg = MIMEText(body, "plain")
    msg["Subject"] = subject
    msg["From"] = MAIL_ADDRESS
    msg["To"] = TO_EMAIL

    try:
        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            server.login(MAIL_ADDRESS, EMAIL_PASSWORD)
            server.sendmail(MAIL_ADDRESS, TO_EMAIL, msg.as_string())
        print("✅ Correo enviado correctamente.")
    except Exception as e:
        print(f"❌ Error al enviar correo: {e}")

if __name__ == "__main__":
    # Solo para pruebas manuales
    cuerpo = """🕒 2025-04-05 19:05:56 - Comprobación de servicios:
✅ cron está activo
❌ ssh está caído
❌ docker está caído
❌ postgresql está caído
❌ nginx está caído
❌ apache2 está caído"""
    send_email("🔴 ALERTA: Servicios caídos detectados", cuerpo)
