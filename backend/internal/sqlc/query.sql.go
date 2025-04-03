// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0
// source: query.sql

package sqlc

import (
	"context"
)

const insertEmail = `-- name: InsertEmail :exec
INSERT INTO email_list (email) VALUES ($1)
`

func (q *Queries) InsertEmail(ctx context.Context, email string) error {
	_, err := q.db.Exec(ctx, insertEmail, email)
	return err
}
