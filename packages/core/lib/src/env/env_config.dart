import 'flavor.dart';

class EnvConfig {
  const EnvConfig._();

  static const String _flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'MonoApp');
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:8080');

  static Flavor get flavor => Flavor.fromString(_flavor);
  static bool get isDev => flavor.isDev;
  static bool get isStg => flavor.isStg;
  static bool get isProd => flavor.isProd;
}
