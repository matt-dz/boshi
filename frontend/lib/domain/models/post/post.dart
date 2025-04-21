import 'package:atproto/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/user/user.dart';

part 'post.freezed.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String title,
    required AtUri uri,
    required String cid,
    required User author,
    required String content,
    required DateTime timestamp,
    required int likes,
    required int numReplies,
    required bool likedByUser,
  }) = _Post;
}
