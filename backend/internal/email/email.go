package email

import (
	"crypto/rand"
	"errors"
	"fmt"
	"math/big"
	"net/smtp"
	"os"
)

const welcomeSubject string = "Welcome to Boshi"
const welcomeBody string = "Thank you for signing up for the Boshi mail list! We are excited that you've decided to join us on our journey. Updates are coming soon."

var host string
var port string
var username string
var password string
var boshiSender string

var ErrMissingEnvVars = errors.New("Missing SMTP environment variables")

func init() {
	host, port, username, password, boshiSender = os.Getenv("SMTP_HOST"), os.Getenv("SMTP_PORT"), os.Getenv("SMTP_USERNAME"), os.Getenv("SMTP_PASSWORD"), os.Getenv("SMTP_FROM")
}

func validateVariables() bool {
	return host == "" || port == "" || username == "" || password == ""
}

func formatMessage(sender, recipient, subject, body string) []byte {
	return []byte(fmt.Sprintf("From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n%s", sender, recipient, subject, body))
}

// Send an email to the recipient with the given subject and body
func SendEmail(recipient string, subject string, body string) error {
	if validateVariables() {
		return ErrMissingEnvVars
	}

	err := smtp.SendMail(
		fmt.Sprintf("%s:%s", host, port),
		smtp.PlainAuth("", username, password, host),
		boshiSender,
		[]string{recipient},
		formatMessage(boshiSender, recipient, subject, body),
	)
	if err != nil {
		return err
	}
	return nil

}

// Generate an 8 digit numeric verification code
func GenerateVerificationCode() (string, error) {
	var maxRand *big.Int = big.NewInt(89_999_999)
	var offset *big.Int = big.NewInt(10_000_000)
	code, err := rand.Int(rand.Reader, maxRand)
	if err != nil {
		return "", err
	}
	code = code.Add(code, offset)
	return code.String(), nil
}
