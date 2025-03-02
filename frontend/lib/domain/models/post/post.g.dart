// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['id'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reactions:
          (json['reactions'] as List<dynamic>).map((e) => e as String).toSet(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Reply.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'reactions': instance.reactions.toList(),
      'comments': instance.comments,
      'title': instance.title,
    };
