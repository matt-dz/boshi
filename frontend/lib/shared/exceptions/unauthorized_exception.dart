class UnauthorizedException implements Exception {
  final String method;
  UnauthorizedException(this.method);

  @override
  String toString() =>
      'UnauthorizedException: User is not authorized to use $method';
}
