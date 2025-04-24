// Package for exceptions

package exceptions

import "errors"

// ErrUnknownUniversity is returned when the university cannot be determined
var ErrUnknownUniversity = errors.New("could not determine your university or school")

