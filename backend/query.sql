-- name: AddToMailList :exec
INSERT INTO mail_list (email) VALUES ($1);

-- name: UpsertEmail :one
INSERT INTO emails (user_id, email)
VALUES ($1, $2) ON CONFLICT (user_id) DO UPDATE
SET email = EXCLUDED.email
RETURNING *;

-- name: VerifyEmail :one
UPDATE emails
SET verified_at = NOW()
WHERE user_id = $1 AND email = $2
RETURNING email;
