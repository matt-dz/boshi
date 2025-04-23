

/// Exception thrown when a user is not found in the system.
class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException([
    this.message = 'User not found',
  ]);

  @override
  String toString() => 'UserNotFoundException: $message';
}
