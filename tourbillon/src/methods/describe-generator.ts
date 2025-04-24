import { Server } from '../lexicon'
import { AppContext } from '../config'
import { feedGenAlgos } from '../algos'
import { AtUri } from '@atproto/syntax'

/**
 * https://docs.bsky.app/docs/api/app-bsky-feed-describe-feed-generator
 * Adds an implementation of describe feed generator to our server.
 */
export default function (server: Server, ctx: AppContext) {
  server.app.bsky.feed.describeFeedGenerator(async () => {
    const feeds = Object.keys(feedGenAlgos).map((shortname) => ({
      uri: AtUri.make(
        ctx.cfg.publisherDid,
        'app.bsky.feed.generator',
        shortname,
      ).toString(),
    }))
    return {
      encoding: 'application/json',
      body: {
        did: ctx.cfg.serviceDid,
        feeds,
      },
    }
  })
}
