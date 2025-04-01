import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import os
import sys

def send_email(subject, body):
    from_email = os.getenv('EMAIL_ADDRESS')
    password = os.getenv('EMAIL_PASSWORD')
    to_email = os.getenv('TO_EMAIL')

    # Crear el objeto del mensaje
    msg = MIMEMultipart()
    msg['From'] = from_email
    msg['To'] = to_email
    msg['Subject'] = subject

    # Adjuntar el cuerpo del mensaje
    msg.attach(MIMEText(body, 'plain'))

    # Configurar el servidor SMTP
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(from_email, password)

    # Enviar el correo electrónico
    text = msg.as_string()
    server.sendmail(from_email, to_email, text)
    server.quit()

if __name__ == '__main__':
    subject = sys.argv[1]
    body = sys.argv[2]
    send_email(subject, body)
