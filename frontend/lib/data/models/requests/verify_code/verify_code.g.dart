// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerifyCodeImpl _$$VerifyCodeImplFromJson(Map<String, dynamic> json) =>
    _$VerifyCodeImpl(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$$VerifyCodeImplToJson(_$VerifyCodeImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'code': instance.code,
    };
