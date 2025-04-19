import { QueryParams as FeedSkeletonQueryParams } from '../lexicon/types/app/bsky/feed/getFeedSkeleton'
import { QueryParams as FeedQueryParams } from '../lexicon/types/app/bsky/feed/getFeed'
import { AppContext } from '../config'
import { Agent } from '@atproto/api'

// max 15 chars
export const shortname = 'boshi'

/**
 * https://docs.bsky.app/docs/api/app-bsky-feed-get-feed-skeleton
 * Handler for server.app.bsky.feed.getFeedSkeleton method
 * @constructor
 * @param {string} ctx - Context
 * @param {string} params - Params for a Get Feed Skeleton Query request
 */
export const handler = async (
  ctx: AppContext,
  params: FeedSkeletonQueryParams,
) => {
  let builder = ctx.db
    .selectFrom('post')
    .selectAll()
    .orderBy('indexed_at', 'desc')
    .limit(params.limit)

  if (params.cursor) {
    const timeStr = new Date(parseInt(params.cursor, 10))
    builder = builder.where('post.indexed_at', '<', timeStr)
  }
  const res = await builder.execute()

  const feed = res.map((row) => ({
    post: row.uri,
  }))

  return {
    feed,
  }
}

/**
 * https://docs.bsky.app/docs/api/app-bsky-feed-get-feed
 * Handler for server.app.bsky.feed.getFeed method
 * Also queries for the user profiles of the posts
 * @constructor
 * @param {string} ctx - Context
 * @param {string} params - Params for a Get Feed Query request
 */
export const feedHandler = async (ctx: AppContext, params: FeedQueryParams) => {
  let builder = ctx.db
    .selectFrom('post')
    .selectAll()
    .orderBy('indexed_at', 'desc')
    .limit(params.limit)

  const res = await builder.execute()

  console.log(res)

  const agent = new Agent('https://public.api.bsky.app')
  const profiles = await agent.getProfiles({
    actors: [...new Set(res.map((row) => row.author_did))],
  })

  const feed = res.map((row) => {
    const author = profiles.data.profiles.filter(
      (profile) => profile.did === row.author_did,
    )[0]

    console.log(author)

    return {
      post: {
        uri: row.uri,
        cid: row.cid,
        author: author,
        record: {
          title: row.title,
          content: row.content,
        },
        indexedAt: row.indexed_at.toISOString(),
      },
    }
  })

  console.log(feed)

  return {
    feed,
  }
}
