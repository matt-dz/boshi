class CodeNotFoundException implements Exception {
  final String message;

  CodeNotFoundException([
    this.message = 'Code not found',
  ]);

  @override
  String toString() => 'CodeNotFoundException: $message';
}
