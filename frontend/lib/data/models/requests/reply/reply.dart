import 'package:freezed_annotation/freezed_annotation.dart';
import '../content_item/content_item.dart';

part 'reply.freezed.dart';
part 'reply.g.dart';

enum ReportReason {
  spam,
  inappropriate,
  other,
}

@freezed
abstract class Reply with _$Reply implements ContentItem {
  const factory Reply({
    required String postId,
    required String authorId,
    required String content,
    required bool likedByUser,
    required String title,
  }) = _Reply;

  factory Reply.fromJson(Map<String, Object?> json) => _$ReplyFromJson(json);
}
