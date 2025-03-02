/// Environment configuration for the application.
class EnvironmentConfig {
  static const backendHost = String.fromEnvironment(
    'BACKEND_HOST',
    defaultValue: 'localhost',
  );

  static const backendPort = String.fromEnvironment(
    'BACKEND_PORT',
    defaultValue: '8080',
  );
}
