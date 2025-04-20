package main

import (
	"boshi-explorer/internal/database"
	"boshi-explorer/internal/logger"
	"boshi-explorer/internal/sqlc"
	"context"
	"encoding/json"
	"fmt"
	"log/slog"
	"os"
	"slices"
	"time"

	apibsky "github.com/bluesky-social/indigo/api/bsky"
	"github.com/bluesky-social/jetstream/pkg/client"
	"github.com/bluesky-social/jetstream/pkg/client/schedulers/sequential"
	"github.com/bluesky-social/jetstream/pkg/models"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/joho/godotenv"
)

var log = logger.GetLogger()

var socketUri string
var firehoseIdentifier string

func init() {
	err := godotenv.Load()
	if err != nil {
		log.Info("Failed to load env -- defaulting to environment")
	}

	socketUri = os.Getenv("SOCKET_URI")
	if socketUri == "" {
		panic("Expected SOCKET_URI to be set")
	}

	firehoseIdentifier = os.Getenv("FIREHOSE_IDENTIFIER")
	if firehoseIdentifier == "" {
		panic("Expected FIREHOSE_IDENTIFIER to be set")
	}
}

const (
	atpPostLexicon = "app.bsky.feed.post"
	boshiPostTag = "boshi.post"
)

func handleEvent(ctx context.Context, event *models.Event) error {
	// Unmarshal the record if there is one
	if event.Commit != nil && (event.Commit.Operation == models.CommitOperationCreate || event.Commit.Operation == models.CommitOperationUpdate) {
		switch event.Commit.Collection {
			case atpPostLexicon:
				var post apibsky.FeedPost
				if err := json.Unmarshal(event.Commit.Record, &post); err != nil {
					return fmt.Errorf("failed to unmarshal post: %w", err)
				}
				if len(post.Tags) != 0 && slices.Contains(post.Tags, boshiPostTag) {
					go storePost(ctx, event, post)
				}
		}
	}

	return nil
}

func storePost(
	ctx context.Context,
	event *models.Event,
	post apibsky.FeedPost,
) {
	timeStamp, err := time.Parse(time.RFC3339, post.CreatedAt)
	if err != nil {
		log.Error("Failed to parse time from post")
		return
	}

	uri := fmt.Sprintf("at://%s/%s/%s", event.Did, event.Commit.Collection, event.Commit.RKey)

	returnedPost, err := database.UseQueries(ctx).CreatePost(ctx, 
		sqlc.CreatePostParams{
			Uri:       uri,
			Cid:       event.Commit.CID,
			AuthorDid: event.Did,
			IndexedAt: pgtype.Timestamptz{Time: timeStamp, Valid: true},
		},
	)

	if err != nil {
		log.Error("Failed to store post", slog.Any("error", err))
	}
	log.Info("Post created", slog.Any("post", returnedPost))
}

func main() {
	ctx := context.Background()
	
	_ = database.UseQueries(ctx)
	defer database.Close()

	jetstreamConfig := client.DefaultClientConfig()
	jetstreamConfig.WantedCollections = []string{"app.bsky.feed.post"}
	jetstreamConfig.WebsocketURL = socketUri
	jetstreamConfig.Compress = true

	scheduler := sequential.NewScheduler(firehoseIdentifier, log, handleEvent)

	c, err := client.NewClient(jetstreamConfig, log, scheduler)
	if err != nil {
		log.Error("failed to create client", slog.Any("error", err))
		return
	}

	cursor := time.Now().Add(-5 * time.Minute).UnixMicro()

	if err := c.ConnectAndRead(ctx, &cursor); err != nil {
		log.Error("failed to connect:", slog.Any("error", err))
	}

	log.Info("shutdown")
}
