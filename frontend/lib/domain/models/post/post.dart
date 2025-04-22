import 'package:atproto/atproto.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:bluesky/bluesky.dart' as bsky;

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

  bsky.Post post;
  final User _author;
  final List<Post>? _replies;
  final StrongRef? _parent;
  final StrongRef? _root;

  User get author => _author;
  List<Post>? get replies => _replies;
  StrongRef? get parent => _parent;
  StrongRef? get root => _root;
}
