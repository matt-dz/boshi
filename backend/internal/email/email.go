// Package for email functions

package email

import (
	"crypto/rand"
	"errors"
	"fmt"
	"net/smtp"
	"os"
	"strings"
)

// Verification code characters
const verificationCodeSet = "ABCDEFGHJKMNOPQRSTUVWXYZ23456789" // Similar characters removed

// Length of the verification code
const verificationCodeLength = 6

var host string = os.Getenv("SMTP_HOST")
var port string = os.Getenv("SMTP_PORT")
var username string = os.Getenv("SMTP_USERNAME")
var password string = os.Getenv("SMTP_PASSWORD")
var boshiSender string = os.Getenv("SMTP_FROM")

var ErrMissingEnvVars = errors.New("Missing SMTP environment variables")

// Determines if the required environment variables are set
func validateVariables() bool {
	return host == "" || port == "" || username == "" || password == "" || boshiSender == ""
}

// Format the email message
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

// Generate an alphanumeric verification code
func GenerateVerificationCode() (string, error) {
	code := make([]byte, verificationCodeLength)
	_, err := rand.Read(code)
	if err != nil {
		return "", err
	}
	for i := range code {
		code[i] = verificationCodeSet[code[i]%byte(len(verificationCodeSet))]
	}
	return string(code), nil
}

// Parse the email address and return the domain
func ParseEmail(address string) (string, error) {
	at := strings.LastIndex(address, "@")
	if at < 0 {
		return "", errors.New("domain not found in email")
	}
	return address[at+1:], nil
}
