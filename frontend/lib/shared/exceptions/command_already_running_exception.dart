class CommandAlreadyRunningException implements Exception {
  final String message;

  CommandAlreadyRunningException([
    this.message = 'Command is already running.',
  ]);

  @override
  String toString() => 'CommandAlreadyRunningException: $message';
}
