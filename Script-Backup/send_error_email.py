import os
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import sys

def send_email(subject, body):
    from_email = os.getenv('MAIL_ADDRESS')
    password = os.getenv('EMAIL_PASSWORD')
    to_email = os.getenv('TO_EMAIL')

    if not from_email or not password or not to_email:
        print("❌ Error: Alguna variable de entorno no está definida.")
        print(f"from_email: {from_email}")
        print(f"password: {'Yes' if password else 'No'}")
        print(f"to_email: {to_email}")
        exit(1)

    msg = MIMEMultipart()
    msg['From'] = from_email
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.starttls()
    server.login(from_email, password)
    server.sendmail(from_email, to_email, msg.as_string())
    server.quit()

if __name__ == '__main__':
    subject = sys.argv[1]
    body = sys.argv[2]
    send_email(subject, body)
