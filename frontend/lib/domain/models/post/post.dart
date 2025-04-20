import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domain/models/user/user.dart';
import 'package:frontend/domain/models/content_item/content_item.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post implements ContentItem {
  const factory Post({
    required String id,
    required User author,
    required String content,
    required DateTime timestamp,
    required int likes,
    required int numReplies,
    required String title,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
