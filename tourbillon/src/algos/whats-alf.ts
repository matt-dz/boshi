import { QueryParams } from '../lexicon/types/app/bsky/feed/getFeedSkeleton'
import { AppContext } from '../config'
import { validateSkeletonFeedPost } from '@atproto/api/dist/client/types/app/bsky/feed/defs'

// max 15 chars
export const shortname = 'whats-alf'

export const handler = async (ctx: AppContext, params: QueryParams) => {
  let builder = ctx.db
    .selectFrom('post')
    .selectAll()
    .orderBy('indexed_at', 'desc')
    .orderBy('cid', 'desc')
    .limit(params.limit)

  if (params.cursor) {
    const timeStr = new Date(parseInt(params.cursor, 10))
    builder = builder.where('post.indexed_at', '<', timeStr)
  }
  const res = await builder.execute()

  const feed = res.map((row) => ({
    post: row.uri,
  }))

  const valid = validateSkeletonFeedPost(feed)
  if (valid.success) console.log('successful validation')
  else console.log('unsuccessful validation')

  return {
    feed,
  }
}
