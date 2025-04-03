package endpoints

import (
	"encoding/json"
	"net/http"
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
