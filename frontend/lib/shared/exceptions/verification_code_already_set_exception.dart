class VerificationCodeAlreadySetException implements Exception {
  final String message;

  VerificationCodeAlreadySetException([
    this.message = 'Verification code is already set.',
  ]);

  @override
  String toString() => 'VerificationCodeAlreadySetException: $message';
}
