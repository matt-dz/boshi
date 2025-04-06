/// Environment configuration for the application.
class EnvironmentConfig {
  static const backendBaseURL = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'localhost',
  );

  static const backendPort = String.fromEnvironment(
    'BACKEND_PORT',
    defaultValue: '8080',
  );
}
