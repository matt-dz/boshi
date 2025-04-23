import 'package:atproto/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/user/user.dart';

part 'reply.freezed.dart';

/// Represents a reply in the Bluesky social network.
@freezed
abstract class Reply with _$Reply {
  const factory Reply({
    required AtUri uri,
    required String cid,
    required User author,
    required String content,
    required DateTime timestamp,
    required int likes,
    required int numReplies,
    required String replyToId,
    required bool likedByUser,
  }) = _Reply;
}
