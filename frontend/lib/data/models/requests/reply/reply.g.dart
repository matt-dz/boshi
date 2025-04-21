// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReplyImpl _$$ReplyImplFromJson(Map<String, dynamic> json) => _$ReplyImpl(
      rootCid: json['root_cid'] as String,
      rootUri: json['root_uri'] as String,
      postCid: json['post_cid'] as String,
      postUri: json['post_uri'] as String,
      authorId: json['author_id'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$ReplyImplToJson(_$ReplyImpl instance) =>
    <String, dynamic>{
      'root_cid': instance.rootCid,
      'root_uri': instance.rootUri,
      'post_cid': instance.postCid,
      'post_uri': instance.postUri,
      'author_id': instance.authorId,
      'content': instance.content,
    };
