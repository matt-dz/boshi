package main

import (
	"boshi-explorer/internal/database"
	"boshi-explorer/internal/logger"
	"boshi-explorer/internal/sqlc"
	"bytes"
	"context"
	"fmt"
	"log/slog"
	"math"
	"slices"

	"net/http"
	"os"
	"strings"
	"time"

	"github.com/bluesky-social/indigo/api/atproto"
	"github.com/bluesky-social/indigo/api/bsky"
	"github.com/bluesky-social/indigo/events"
	"github.com/bluesky-social/indigo/events/schedulers/sequential"
	"github.com/bluesky-social/indigo/repo"
	"github.com/gorilla/websocket"
	"github.com/ipfs/go-cid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/joho/godotenv"
)

var log = logger.GetLogger()

var uri string
var firehoseIdentifier string

const retries = 5
const baseDelay = 100 * time.Millisecond

func init() {
	err := godotenv.Load()
	if err != nil {
		log.Info("Failed to load env -- defaulting to environment")
	}

	uri = os.Getenv("SOCKET_URI")
	if uri == "" {
		panic("Expected SOCKET_URI to be set")
	}

	firehoseIdentifier = os.Getenv("FIREHOSE_IDENTIFIER")
	if firehoseIdentifier == "" {
		panic("Expected FIREHOSE_IDENTIFIER to be set")
	}
}

func runExplorer(workScheduler *sequential.Scheduler) {
	for {
		var firehoseConnection *websocket.Conn = nil
		var err error

		log.Debug("Connecting to firehose", "uri", uri)

		for i := range retries {
			firehoseConnection, _, err = websocket.DefaultDialer.Dial(uri, http.Header{})
			if err != nil {
				delay := time.Duration(math.Pow(2, float64(i))) * baseDelay
				log.Error("WebSocket retry", slog.Int("attempt", i+1), slog.Any("waiting", delay), slog.Any("error", err))
				time.Sleep(delay)
				continue
			} else {
				break
			}
		}

		if firehoseConnection == nil {
			log.Error("Failed to establish a connection -- killing explorer.")
			break
		}

		/* Create event processor and connect it to the firehose */
		log.Debug("Starting repo stream")

		err = events.HandleRepoStream(context.Background(), firehoseConnection, workScheduler, log)
		if err != nil {
			log.Error("Failed while handling firehose stream", slog.Any("error", err))
		}
	}
}

func HandleStoringPost(
	feedPost bsky.FeedPost,
	evt *atproto.SyncSubscribeRepos_Commit,
	op *atproto.SyncSubscribeRepos_RepoOp,
	cid cid.Cid,
	queries *sqlc.Queries,
) {
	timeStamp, err := time.Parse(time.RFC3339, feedPost.CreatedAt)
	if err != nil {
		log.Error("Failed to parse time from post")
		return
	}

	uri := fmt.Sprintf("at://%s/%s", evt.Repo, op.Path)

	storedPost := sqlc.CreatePostParams{
		Uri:       uri,
		Cid:       cid.String(),
		AuthorDid: evt.Repo,
		IndexedAt: pgtype.Timestamptz{Time: timeStamp, Valid: true},
	}

	returnedPost, err := queries.CreatePost(context.Background(), storedPost)
	if err != nil {
		log.Error("Failed to store post", slog.Any("error", err))
	} else {
		log.Info("Post created", slog.Any("post", returnedPost))
	}
}

func UnmarshalAndStorePost(
	evt *atproto.SyncSubscribeRepos_Commit,
	queries *sqlc.Queries,
) {
	blocks := evt.Blocks
	r, err := repo.ReadRepoFromCar(context.Background(), bytes.NewReader(blocks))
	if err != nil {
		log.Error("Failed to get repo from blocks")
	}

	for _, op := range evt.Ops {
		if strings.HasPrefix(op.Path, "app.bsky.feed.post") {
			cid, post, err := r.GetRecordBytes(context.Background(), op.Path)
			if err != nil {
				continue
			}
			
			log.Info("smth", slog.Any("post", post))

			var feedPost bsky.FeedPost
			feedPost.UnmarshalCBOR(bytes.NewReader(*post))

			if len(feedPost.Tags) != 0 && slices.Contains(feedPost.Tags, "boshi.post") {
				HandleStoringPost(feedPost, evt, op, cid, queries)
			}
		}
	}
}


func main() {

	log.Debug("Connecting to postgres")
	pool := database.Connect(context.Background())
	defer pool.Close()
	queries := sqlc.New(pool)

	repoCallbacks := &events.RepoStreamCallbacks{
		RepoCommit: func(evt *atproto.SyncSubscribeRepos_Commit) error {
			go UnmarshalAndStorePost(evt, queries)
			return nil
		},
	}

	workScheduler := sequential.NewScheduler(firehoseIdentifier, repoCallbacks.EventHandler)
	runExplorer(workScheduler)
}
