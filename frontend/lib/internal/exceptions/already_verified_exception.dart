class AlreadyVerifiedException implements Exception {
  final String message;

  AlreadyVerifiedException([
    this.message = 'User is already verified.',
  ]);

  @override
  String toString() => 'AlreadyVerifiedException: $message';
}
