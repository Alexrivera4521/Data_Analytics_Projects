# import libraries
from bs4 import BeautifulSoup
import smtplib
import requests
import time
import datetime
import csv
import os

# Function to check the price of the product
def check_price():
    # Connect to the website
    url = 'https://www.amazon.com/Nespresso-Vertuo-Pacific-Coffee-Maker/dp/B0BXBGP17P/?_encoding=UTF8&pd_rd_w=o7DcZ&content-id=amzn1.sym.255b3518-6e7f-495c-8611-30a58648072e%3Aamzn1.symc.a68f4ca3-28dc-4388-a2cf-24672c480d8f&pf_rd_p=255b3518-6e7f-495c-8611-30a58648072e&pf_rd_r=B6B8B6V9YJBVWH3MSECD&pd_rd_wg=Btprj&pd_rd_r=d2c7b588-ba62-4735-8e25-9a212d78ae90&ref_=pd_hp_d_atf_ci_mcx_mr_ca_hp_atf_d&th=1'
    
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
        "Accept-Language": "en-US,en;q=0.9",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
    }
    
    # Fetch the page content
    page = requests.get(url, headers=headers)
    soup1 = BeautifulSoup(page.content, "html.parser")
    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
    
    # Extract the product title and price
    product = soup2.find(id='productTitle').get_text().strip()
    price = float(soup2.find(class_='aok-offscreen').get_text().strip()[1:].replace(',', ''))

    today = datetime.date.today()

    # File path for the CSV file
    directory = r'C:\Users\arive336\Downloads'
    file_name = 'AmazonProductPriceAlert.csv'
    file_path = os.path.join(directory, file_name)
    
    # Read the last recorded price from the CSV file, if it exists
    if os.path.exists(file_path):
        with open(file_path, 'r', newline='', encoding='UTF8') as f:
            reader = csv.reader(f)
            data = list(reader)
            last_price = float(data[-1][1])
    else:
        last_price = price  # If file doesn't exist, assume no previous price

    # Check if the price has dropped
    if price < last_price:
        # Append new data to the CSV file
        with open(file_path, 'a+', newline='', encoding='UTF8') as f:
            writer = csv.writer(f)
            writer.writerow([product, price, today])

        # Send email alert with the CSV file as attachment
        send_mail(file_path, product, price)
    
    print(f"Checked {product} on {today}: Current price is ${price}")

# Function to send an email with the CSV file attached
def send_mail(file_path, product, price):
    # Setup email server
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login('your_email@gmail.com', 'your_app_password')

    # Email content
    subject = f"{product} Price Alert: Now ${price}!"
    body = f"Check the attached CSV file for price history of {product}."
    msg = f"Subject: {subject}\n\n{body}"

    # Create email with attachment
    from email.message import EmailMessage
    email = EmailMessage()
    email['From'] = 'your_email@gmail.com'
    email['To'] = 'recipient_email@gmail.com'
    email['Subject'] = subject
    email.set_content(body)
    
    # Attach the CSV file
    with open(file_path, 'rb') as f:
        email.add_attachment(f.read(), maintype='application', subtype='octet-stream', filename='Pricealert.csv')

    # Send the email
    server.send_message(email)
    server.quit()

    print(f"Email sent: {subject}")

# Run the check every 24 hours
while True:
    check_price()
    time.sleep(86400)  # 86400 seconds = 24 hours
