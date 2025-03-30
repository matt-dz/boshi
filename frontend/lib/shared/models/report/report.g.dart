// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      postId: json['postId'] as String,
      reporterId: json['reporterId'] as String,
      reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'reporterId': instance.reporterId,
      'reason': _$ReportReasonEnumMap[instance.reason]!,
      'description': instance.description,
    };

const _$ReportReasonEnumMap = {
  ReportReason.spam: 'spam',
  ReportReason.inappropriate: 'inappropriate',
  ReportReason.other: 'other',
};
