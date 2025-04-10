import { QueryParams as FeedSkeletonQueryParams } from '../lexicon/types/app/bsky/feed/getFeedSkeleton'
import { QueryParams as FeedQueryParams } from '../lexicon/types/app/bsky/feed/getFeed'
import { AppContext } from '../config'
import { Agent } from '@atproto/api'

// max 15 chars
export const shortname = 'boshi'

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

export const feedHandler = async (ctx: AppContext, params: FeedQueryParams) => {
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

  const agent = new Agent('https://bsky.social')
  const profiles = await agent.getProfiles({
    actors: res.map((row) => row.author_did),
  })

  const feed = res.map((row) => {
    const author = profiles.data.profiles.filter(
      (profile) => profile.did === row.author_did,
    )[0]

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

  return {
    feed,
  }
}
