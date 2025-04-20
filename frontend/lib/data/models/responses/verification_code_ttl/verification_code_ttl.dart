import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_code_ttl.freezed.dart';
part 'verification_code_ttl.g.dart';

@freezed
abstract class VerificationCodeTTL with _$VerificationCodeTTL {
  const factory VerificationCodeTTL({
    required double ttl,
  }) = _VerificationCodeTTL;

  factory VerificationCodeTTL.fromJson(Map<String, Object?> json) =>
      _$VerificationCodeTTLFromJson(json);
}
