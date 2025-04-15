class VerificationCodeAlreadySetException implements Exception {
  final String message;

  VerificationCodeAlreadySetException([
    this.message = 'Command is already running.',
  ]);

  @override
  String toString() => 'VerificationCodeAlreadySetException: $message';
}
