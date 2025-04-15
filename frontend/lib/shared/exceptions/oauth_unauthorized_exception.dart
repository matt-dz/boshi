class OAuthUnauthorized implements Exception {
  final String message;

  OAuthUnauthorized([
    this.message = 'Unauthorized.',
  ]);

  @override
  String toString() => 'OAuthUnauthorized: $message';
}
