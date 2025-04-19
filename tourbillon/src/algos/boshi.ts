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
    .select(['uri'])
    .orderBy('indexed_at', 'desc')
    .limit(params.limit)

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
    .innerJoin('emails', 'post.author_did', 'emails.user_id')
    .select([
      'post.author_did',
      'post.cid',
      'post.uri',
      'post.title',
      'post.content',
      'post.indexed_at',
      'emails.school as school',
    ])
    .orderBy('post.indexed_at', 'desc')
    .limit(params.limit)

  const res = await builder.execute()

  const agent = new Agent('https://public.api.bsky.app')
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
          school: row.school,
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
