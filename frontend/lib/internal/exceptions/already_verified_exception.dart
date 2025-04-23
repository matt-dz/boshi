

/// Exception thrown when a user tries to verify an 
/// account that is already verified.
class AlreadyVerifiedException implements Exception {
  final String message;

  AlreadyVerifiedException([
    this.message = 'User is already verified.',
  ]);

  @override
  String toString() => 'AlreadyVerifiedException: $message';
}
