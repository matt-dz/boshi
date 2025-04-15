export type DatabaseSchema = {
  post: Post
  sub_state: SubState
  reaction: Reaction
  reply: Reply
}

export type Email = {
  user_id: string
  email: string
  school: string
  created_at: Date
  verified_at: Date
}

export type MailList = {
  email: string
  created_at: Date
}

export type Post = {
  uri: string
  cid: string
  indexedAt: string
}

export type SubState = {
  service: string
  cursor: number
}
