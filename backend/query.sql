-- name: AddToMailList :exec
INSERT INTO mail_list (email) VALUES ($1);

-- name: AddUnverifiedEmail :one
INSERT INTO emails (email)
VALUES ($1) ON CONFLICT (email) DO UPDATE
SET email = EXCLUDED.email
RETURNING *;

-- name: VerifyEmail :one
UPDATE emails SET verified_at = NOW() WHERE email = $1 RETURNING email;
