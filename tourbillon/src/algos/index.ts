import { AppContext } from '../config'
import {
  QueryParams,
  OutputSchema as AlgoOutput,
} from '../lexicon/types/app/bsky/feed/getFeedSkeleton'
import {
  QueryParams as FeedQueryParams,
  OutputSchema as FeedAlgoOutput,
} from '../lexicon/types/app/bsky/feed/getFeed'

import * as boshi from './boshi'

type AlgoHandler = (ctx: AppContext, params: QueryParams) => Promise<AlgoOutput>
type FeedAlgoHandler = (
  ctx: AppContext,
  params: FeedQueryParams,
) => Promise<FeedAlgoOutput>

export const feedGenAlgos: Record<string, AlgoHandler> = {
  [boshi.shortname]: boshi.handler,
}

export const feedAlgos: Record<string, FeedAlgoHandler> = {
  [boshi.shortname]: boshi.feedHandler,
}
