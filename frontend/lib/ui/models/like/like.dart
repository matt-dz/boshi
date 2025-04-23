import 'package:freezed_annotation/freezed_annotation.dart';

part 'like.freezed.dart';
part 'like.g.dart';

/// Class to represent a like action on a post.
@freezed
abstract class Like with _$Like {
  factory Like({
    required String uri,
    required String cid,
    required bool like,
  }) = _Login;

  factory Like.fromJson(Map<String, Object?> json) => _$LikeFromJson(json);
}
