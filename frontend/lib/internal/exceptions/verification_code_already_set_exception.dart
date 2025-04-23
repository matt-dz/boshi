

/// Exception thrown when a verification code is already set for a user.
class VerificationCodeAlreadySetException implements Exception {
  final String message;

  VerificationCodeAlreadySetException([
    this.message = 'Verification code is already set.',
  ]);

  @override
  String toString() => 'VerificationCodeAlreadySetException: $message';
}
