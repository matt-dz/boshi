class NotAuthorizedException implements Exception {
  final String method;
  NotAuthorizedException(this.method);

  @override
  String toString() => 'NotAuthorizedException: Not authorized to use $method';
}
