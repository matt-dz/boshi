import 'package:freezed_annotation/freezed_annotation.dart';

part 'reply.freezed.dart';
part 'reply.g.dart';

@freezed
abstract class Reply with _$Reply {
  const factory Reply({
    required String rootCid,
    required String rootUri,
    required String postCid,
    required String postUri,
    required String authorId,
    required String content,
  }) = _Reply;

  factory Reply.fromJson(Map<String, Object?> json) => _$ReplyFromJson(json);
}
