export type DatabaseSchema = {
  email: Email
  mailList: MailList
  post: Post
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
  author_did: string
  indexed_at: Date
  title: string
  content: string
}

export type Reaction = {
  uri: string
  post_uri: string
  author_did: string
  indexed_at: Date
  emote: string
}

export type Reply = {
  uri: string
  cid: string
  author_did: string
  indexed_at: Date
  title: string
  content: string
  reply_to_uri: string
}
