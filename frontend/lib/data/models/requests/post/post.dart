import 'package:freezed_annotation/freezed_annotation.dart';
import '../content_item/content_item.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post implements ContentItem {
  const factory Post({
    required String authorId,
    required String content,
    required String title,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}
