// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReplyImpl _$$ReplyImplFromJson(Map<String, dynamic> json) => _$ReplyImpl(
      id: json['id'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      likes: (json['likes'] as num).toInt(),
      numReplies: (json['num_replies'] as num).toInt(),
      replyToId: json['reply_to_id'] as String,
    );

Map<String, dynamic> _$$ReplyImplToJson(_$ReplyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'likes': instance.likes,
      'num_replies': instance.numReplies,
      'reply_to_id': instance.replyToId,
    };
