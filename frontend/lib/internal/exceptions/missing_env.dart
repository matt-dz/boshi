class MissingEnvException implements Exception {
  final String env;
  MissingEnvException(this.env);

  @override
  String toString() =>
      'MissingEnvException: Missing environment variable - $env';
}
