package email

import (
	"crypto/rand"
	"errors"
	"fmt"
	"math/big"
	"net/smtp"
	"os"
)

var host string = os.Getenv("SMTP_HOST")
var port string = os.Getenv("SMTP_PORT")
var username string = os.Getenv("SMTP_USERNAME")
var password string = os.Getenv("SMTP_PASSWORD")
var boshiSender string = os.Getenv("SMTP_FROM")

var ErrMissingEnvVars = errors.New("Missing SMTP environment variables")

func validateVariables() bool {
	return host == "" || port == "" || username == "" || password == "" || boshiSender == ""
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
