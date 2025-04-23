import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_code.freezed.dart';
part 'verification_code.g.dart';

/// Represent the action of verifying a code sent to a user's email.
@freezed
abstract class VerificationCode with _$VerificationCode {
  factory VerificationCode({
    required String email,
    required String code,
  }) = _VerificationCode;

  factory VerificationCode.fromJson(Map<String, Object?> json) =>
      _$VerificationCodeFromJson(json);
}
