

/// Exception representing an unauthorized OAuth request.
class OAuthUnauthorizedException implements Exception {
  final String message;

  OAuthUnauthorizedException([
    this.message = 'Unauthorized.',
  ]);

  @override
  String toString() => 'OAuthUnauthorized: $message';
}
