-- name: GetPost :one
SELECT * FROM post
WHERE uri = $1 LIMIT 1;

-- name: ListPosts :many
SELECT * FROM post
ORDER BY "indexedAt";

-- name: CreatePost :one
INSERT INTO post (
  uri, cid, "indexedAt"
) VALUES (
  $1, $2, $3
)
RETURNING *;

-- name: DeletePost :exec
DELETE FROM post
WHERE uri = $1;