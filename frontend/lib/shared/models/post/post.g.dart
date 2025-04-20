// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      school: json['school'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      indexedAt: DateTime.parse(json['indexed_at'] as String),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'school': instance.school,
      'title': instance.title,
      'content': instance.content,
      'indexed_at': instance.indexedAt.toIso8601String(),
    };
