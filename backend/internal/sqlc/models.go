// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0

package sqlc

import (
	"database/sql/driver"
	"fmt"

	"github.com/jackc/pgx/v5/pgtype"
)

type VerifyEmailResult string

const (
	VerifyEmailResultNoMatch         VerifyEmailResult = "no_match"
	VerifyEmailResultAlreadyVerified VerifyEmailResult = "already_verified"
	VerifyEmailResultJustVerified    VerifyEmailResult = "just_verified"
)

func (e *VerifyEmailResult) Scan(src interface{}) error {
	switch s := src.(type) {
	case []byte:
		*e = VerifyEmailResult(s)
	case string:
		*e = VerifyEmailResult(s)
	default:
		return fmt.Errorf("unsupported scan type for VerifyEmailResult: %T", src)
	}
	return nil
}

type NullVerifyEmailResult struct {
	VerifyEmailResult VerifyEmailResult
	Valid             bool // Valid is true if VerifyEmailResult is not NULL
}

// Scan implements the Scanner interface.
func (ns *NullVerifyEmailResult) Scan(value interface{}) error {
	if value == nil {
		ns.VerifyEmailResult, ns.Valid = "", false
		return nil
	}
	ns.Valid = true
	return ns.VerifyEmailResult.Scan(value)
}

// Value implements the driver Valuer interface.
func (ns NullVerifyEmailResult) Value() (driver.Value, error) {
	if !ns.Valid {
		return nil, nil
	}
	return string(ns.VerifyEmailResult), nil
}

type Email struct {
	UserID     string
	Email      string
	CreatedAt  pgtype.Timestamptz
	VerifiedAt pgtype.Timestamptz
	School     pgtype.Text
}

type MailList struct {
	Email     string
	CreatedAt pgtype.Timestamptz
}

type Post struct {
	Uri       string
	Cid       string
	AuthorDid string
	IndexedAt pgtype.Timestamptz
}

type Reaction struct {
	Uri       string
	PostUri   pgtype.Text
	AuthorDid string
	IndexedAt pgtype.Timestamptz
	Emote     string
}

type Reply struct {
	Uri        string
	Cid        string
	AuthorDid  string
	IndexedAt  pgtype.Timestamptz
	Title      string
	Content    string
	ReplyToUri string
}
