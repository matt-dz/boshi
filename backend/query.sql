-- name: AddToMailList :exec
INSERT INTO mail_list (email) VALUES ($1);

-- name: UpsertEmail :one
INSERT INTO emails (user_id, email)
VALUES ($1, $2)
ON CONFLICT (user_id) DO UPDATE
SET email = EXCLUDED.email
WHERE emails.verified_at IS NULL
RETURNING *;


-- name: VerifyEmail :one
WITH matched AS (
    SELECT *
    FROM emails
    WHERE emails.user_id = $1 AND emails.email = $2
),
updated AS (
    UPDATE emails
    SET verified_at = NOW()
    WHERE (user_id, email) IN (SELECT matched.user_id, matched.email FROM matched WHERE matched.verified_at IS NULL)
    RETURNING *
)
SELECT
    CASE
        WHEN NOT EXISTS (SELECT 1 FROM matched) THEN 'no_match'::verification_status
        WHEN EXISTS (SELECT 1 FROM matched WHERE verified_at IS NOT NULL) THEN 'already_verified'::verification_status
        ELSE 'just_verified'::verification_status
    END AS status;

-- name: GetUser :one
SELECT school, verified_at
FROM emails
WHERE emails.user_id = $1;
