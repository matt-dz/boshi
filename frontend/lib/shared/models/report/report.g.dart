// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      postId: json['post_id'] as String,
      reporterId: json['reporter_id'] as String,
      reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'reporter_id': instance.reporterId,
      'reason': _$ReportReasonEnumMap[instance.reason]!,
      'description': instance.description,
    };

const _$ReportReasonEnumMap = {
  ReportReason.spam: 'spam',
  ReportReason.inappropriate: 'inappropriate',
  ReportReason.other: 'other',
};
