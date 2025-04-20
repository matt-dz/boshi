import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_code.freezed.dart';
part 'verify_code.g.dart';

@freezed
abstract class VerifyCode with _$VerifyCode {
  const factory VerifyCode({
    required String userId,
    required String email,
    required String code,
  }) = _VerifyCode;

  factory VerifyCode.fromJson(Map<String, Object?> json) =>
      _$VerifyCodeFromJson(json);
}
