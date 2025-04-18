class UnauthorizedException implements Exception {
  final String method;
  UnauthorizedException(this.method);

  @override
  String toString() => 'NotAuthorizedException: Not authorized to use $method';
}
