-- name: GetPost :one
SELECT * FROM posts
WHERE uri = $1 LIMIT 1;

-- name: ListPosts :many
SELECT * FROM posts
ORDER BY indexedAt;

-- name: CreatePost :one
INSERT INTO posts (
  uri, cid, indexedAt
) VALUES (
  $1, $2, $3
)
RETURNING *;

-- name: DeletePost :exec
DELETE FROM posts
WHERE uri = $1;