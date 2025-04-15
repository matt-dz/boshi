import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_status.freezed.dart';
part 'verification_status.g.dart';

@freezed
abstract class VerificationStatus with _$VerificationStatus {
  const factory VerificationStatus({
    required bool verified,
  }) = _VerificationStatus;

  factory VerificationStatus.fromJson(Map<String, Object?> json) =>
      _$VerificationStatusFromJson(json);
}
