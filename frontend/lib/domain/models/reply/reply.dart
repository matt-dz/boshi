import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/domain/models/content_item/content_item.dart';
import 'package:frontend/domain/models/reaction/reaction.dart';

part 'reply.freezed.dart';
part 'reply.g.dart';

@freezed
abstract class Reply with _$Reply implements ContentItem {
  const factory Reply({
    required String id,
    required User author,
    required String content,
    required DateTime timestamp,
    required List<Reaction> reactions,
    required List<Reply> comments,
    required String replyToId,
  }) = _Reply;

  factory Reply.fromJson(Map<String, Object?> json) => _$ReplyFromJson(json);
}
