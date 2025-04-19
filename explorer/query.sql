-- name: GetPost :one
SELECT * FROM post
WHERE uri = $1 LIMIT 1;

-- name: ListPosts :many
SELECT * FROM post
ORDER BY indexed_at;

-- name: CreatePost :one
INSERT INTO post (
  uri, cid, author_did, indexed_at
) VALUES (
  $1, $2, $3, $4
)
RETURNING *;

-- name: DeletePost :exec
DELETE FROM post
WHERE uri = $1;
