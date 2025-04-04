import os
import smtplib
from email.message import EmailMessage
import sys

from_email = os.getenv('MAIL_ADDRESS')
password = os.getenv('EMAIL_PASSWORD')
to_email = os.getenv('TO_EMAIL')

msg = EmailMessage()
msg['Subject'] = sys.argv[1]
msg['From'] = from_email
msg['To'] = to_email

# Leer resumen diario
with open(sys.argv[2], 'r') as f:
    body = f.read()
msg.set_content(body)

try:
    with smtplib.SMTP('smtp.gmail.com', 587) as server:
        server.starttls()
        server.login(from_email, password)
        server.send_message(msg)
except Exception as e:
    print(f"Error al enviar el resumen diario: {e}")
