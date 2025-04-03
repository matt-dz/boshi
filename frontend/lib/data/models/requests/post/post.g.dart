// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      authorId: json['author_id'] as String,
      content: json['content'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'author_id': instance.authorId,
      'content': instance.content,
      'title': instance.title,
    };
