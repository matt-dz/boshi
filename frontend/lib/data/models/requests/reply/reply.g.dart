// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReplyImpl _$$ReplyImplFromJson(Map<String, dynamic> json) => _$ReplyImpl(
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      content: json['content'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$$ReplyImplToJson(_$ReplyImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'authorId': instance.authorId,
      'content': instance.content,
      'title': instance.title,
    };
