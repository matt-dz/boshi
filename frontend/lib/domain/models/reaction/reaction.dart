import 'package:freezed_annotation/freezed_annotation.dart';

part 'reaction.freezed.dart';
part 'reaction.g.dart';

@freezed
abstract class Reaction with _$Reaction {
  const factory Reaction({
    required String emote,
    required int count,
  }) = _Reaction;

  factory Reaction.fromJson(Map<String, Object?> json) =>
      _$ReactionFromJson(json);
}
