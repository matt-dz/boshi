import 'package:atproto/atproto.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:bluesky/bluesky.dart' as bsky;

/// Represents a post in the Bluesky social network.
class Post {
  Post({
    required bsky.Post bskyPost,
    required User author,
    List<Post>? replies,
    StrongRef? parent,
    StrongRef? root,
  })  : post = bskyPost,
        _author = author,
        _replies = replies,
        _parent = parent,
        _root = root;

	/// The post object from the Bluesky API.
  bsky.Post post;

	/// The author of the post.
  final User _author;

	/// The replies to the post.
  final List<Post>? _replies;

	/// The parent post if this post is a reply.
  final StrongRef? _parent;

	/// The root post if this post is part of a thread.
  final StrongRef? _root;

  User get author => _author;
  List<Post>? get replies => _replies;
  StrongRef? get parent => _parent;
  StrongRef? get root => _root;
}
