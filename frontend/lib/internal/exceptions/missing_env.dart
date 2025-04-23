

/// Excpetion thrown when there is a missing environment variable.
class MissingEnvException implements Exception {
  final String env;
  MissingEnvException(this.env);

  @override
  String toString() =>
      'MissingEnvException: Missing environment variable - $env';
}
