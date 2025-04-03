package email

import (
	"errors"
	"fmt"
	"net/smtp"
	"os"
)

const welcomeSubject string = "Welcome to Boshi"
const welcomeBody string = "Thank you for signing up for the Boshi mail list! We are excited that you've decided to join us on our journey. Updates are coming soon."

func formatMessage(sender, recipient, subject, body string) []byte {
	return []byte(fmt.Sprintf("From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n%s", sender, recipient, subject, body))
}

func SendEmailListWelcome(recipient string) error {
	/* Send email */
	host, port, username, password, boshiSender := os.Getenv("SMTP_HOST"), os.Getenv("SMTP_PORT"), os.Getenv("SMTP_USERNAME"), os.Getenv("SMTP_PASSWORD"), os.Getenv("SMTP_FROM")
	if host == "" || port == "" || username == "" || password == "" {
		return errors.New("Missing SMTP environment variables")
	}

	err := smtp.SendMail(
		fmt.Sprintf("%s:%s", host, port),
		smtp.PlainAuth("", username, password, host),
		boshiSender,
		[]string{recipient},
		formatMessage(boshiSender, recipient, welcomeSubject, welcomeBody),
	)
	if err != nil {
		return err
	}
	return nil
}
