import 'package:freezed_annotation/freezed_annotation.dart';

part 'reaction_payload.freezed.dart';
part 'reaction_payload.g.dart';

@freezed
abstract class ReactionPayload with _$ReactionPayload {
  const factory ReactionPayload({
    required String emote,
    required int delta,
    required String postId,
  }) = _ReactionPayload;

  factory ReactionPayload.fromJson(Map<String, Object?> json) =>
      _$ReactionPayloadFromJson(json);
}
