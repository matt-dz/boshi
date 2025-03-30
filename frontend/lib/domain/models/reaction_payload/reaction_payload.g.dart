// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactionPayloadImpl _$$ReactionPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$ReactionPayloadImpl(
      emote: json['emote'] as String,
      delta: (json['delta'] as num).toInt(),
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$$ReactionPayloadImplToJson(
        _$ReactionPayloadImpl instance) =>
    <String, dynamic>{
      'emote': instance.emote,
      'delta': instance.delta,
      'postId': instance.postId,
    };
