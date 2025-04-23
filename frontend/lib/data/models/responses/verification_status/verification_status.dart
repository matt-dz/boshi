import 'package:freezed_annotation/freezed_annotation.dart';

part 'verification_status.freezed.dart';
part 'verification_status.g.dart';

/// Class to represent the verification status of a user's email.
@freezed
abstract class VerificationStatus with _$VerificationStatus {
  const factory VerificationStatus({
    required bool verified,
  }) = _VerificationStatus;

  factory VerificationStatus.fromJson(Map<String, Object?> json) =>
      _$VerificationStatusFromJson(json);
}
