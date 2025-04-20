import { AppContext } from '../config'
import {
  QueryParams,
  OutputSchema as AlgoOutput,
} from '../lexicon/types/app/bsky/feed/getFeedSkeleton'

import * as boshi from './boshi'

type AlgoHandler = (ctx: AppContext, params: QueryParams) => Promise<AlgoOutput>

export const feedGenAlgos: Record<string, AlgoHandler> = {
  [boshi.shortname]: boshi.handler,
}
