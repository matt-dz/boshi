/// Environment configuration for the application.
class EnvironmentConfig {
  static const backendBaseURL = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const prod = bool.fromEnvironment(
    'PROD',
    defaultValue: false,
  );
  static const frontendPort = int.fromEnvironment(
    'FRONTEND_PORT',
    defaultValue: 3000,
  );
  static const feedGenUri = String.fromEnvironment(
    'FEED_GENERATOR_URI',
    defaultValue: '',
  );
}
