import 'package:frontend/domain/models/user/user.dart';
import 'package:bluesky/bluesky.dart' as bsky;

class Post {
  Post({
    required bsky.Post bskyPost,
    required User author,
  })  : post = bskyPost,
        _author = author;

  bsky.Post post;
  final User _author;

  User get author => _author;
}
