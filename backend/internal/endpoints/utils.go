package endpoints

import (
	"encoding/json"
	"errors"
	"net/http"
	"strings"
)

func decodeJson(dst interface{}, r *http.Request) error {
	decoder := json.NewDecoder(r.Body)
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(dst); err != nil {
		return err
	}
	defer r.Body.Close()
	return nil
}

func parseEmail(address string) (string, error) {
	at := strings.LastIndex(address, "@")
	if at >= 0 {
			domain := address[at+1:]
			return domain, nil
	} else {
		return "", errors.New("Domain not found in email")
	}
} 