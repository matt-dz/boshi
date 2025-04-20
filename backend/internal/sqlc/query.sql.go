// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.25.0
// source: query.sql

package sqlc

import (
	"context"

	"github.com/jackc/pgx/v5/pgtype"
)

const addToMailList = `-- name: AddToMailList :exec
INSERT INTO mail_list (email) VALUES ($1)
`

func (q *Queries) AddToMailList(ctx context.Context, email string) error {
	_, err := q.db.Exec(ctx, addToMailList, email)
	return err
}

const getUser = `-- name: GetUser :one
SELECT school, verified_at
FROM emails
WHERE emails.user_id = $1
`

type GetUserRow struct {
	School     pgtype.Text
	VerifiedAt pgtype.Timestamptz
}

func (q *Queries) GetUser(ctx context.Context, userID string) (GetUserRow, error) {
	row := q.db.QueryRow(ctx, getUser, userID)
	var i GetUserRow
	err := row.Scan(&i.School, &i.VerifiedAt)
	return i, err
}

const upsertEmail = `-- name: UpsertEmail :one
INSERT INTO emails (user_id, email)
VALUES ($1, $2)
ON CONFLICT (user_id) DO UPDATE
SET email = EXCLUDED.email
WHERE emails.verified_at IS NULL
RETURNING user_id, email, school, created_at, verified_at
`

type UpsertEmailParams struct {
	UserID string
	Email  string
}

func (q *Queries) UpsertEmail(ctx context.Context, arg UpsertEmailParams) (Email, error) {
	row := q.db.QueryRow(ctx, upsertEmail, arg.UserID, arg.Email)
	var i Email
	err := row.Scan(
		&i.UserID,
		&i.Email,
		&i.School,
		&i.CreatedAt,
		&i.VerifiedAt,
	)
	return i, err
}

const verifyEmail = `-- name: VerifyEmail :one
WITH matched AS (
    SELECT user_id, email, school, created_at, verified_at
    FROM emails
    WHERE emails.user_id = $1 AND emails.email = $2
),
updated AS (
    UPDATE emails
    SET verified_at = NOW()
    WHERE (user_id, email) IN (SELECT matched.user_id, matched.email FROM matched WHERE matched.verified_at IS NULL)
    RETURNING user_id, email, school, created_at, verified_at
)
SELECT
    CASE
        WHEN NOT EXISTS (SELECT 1 FROM matched) THEN 'no_match'::verification_status
        WHEN EXISTS (SELECT 1 FROM matched WHERE verified_at IS NOT NULL) THEN 'already_verified'::verification_status
        ELSE 'just_verified'::verification_status
    END AS status
`

type VerifyEmailParams struct {
	UserID string
	Email  string
}

func (q *Queries) VerifyEmail(ctx context.Context, arg VerifyEmailParams) (VerificationStatus, error) {
	row := q.db.QueryRow(ctx, verifyEmail, arg.UserID, arg.Email)
	var status VerificationStatus
	err := row.Scan(&status)
	return status, err
}
