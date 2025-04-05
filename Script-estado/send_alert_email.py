import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from dotenv import load_dotenv

load_dotenv("/usr/local/bin/.env")

MAIL_ADDRESS = os.getenv("MAIL_ADDRESS")
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD")
TO_EMAIL = os.getenv("TO_EMAIL")

import sys
subject = sys.argv[1]
log_path = sys.argv[2]

message = MIMEMultipart()
message["From"] = MAIL_ADDRESS
message["To"] = TO_EMAIL
message["Subject"] = subject

body = MIMEText("Uno o más recursos del sistema han superado el 60%.\nSe adjunta el log con detalles.", "plain")
message.attach(body)

with open(log_path, "rb") as file:
    part = MIMEApplication(file.read(), Name=os.path.basename(log_path))
    part['Content-Disposition'] = f'attachment; filename="{os.path.basename(log_path)}"'
    message.attach(part)

try:
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(MAIL_ADDRESS, EMAIL_PASSWORD)
        server.sendmail(MAIL_ADDRESS, TO_EMAIL, message.as_string())
    print("✅ Correo de alerta enviado.")
except Exception as e:
    print("❌ Error al enviar correo:", str(e))
