-- name: InsertEmail :exec
INSERT INTO email_list (email) VALUES ($1);
