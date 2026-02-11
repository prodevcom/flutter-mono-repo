import 'package:logger/logger.dart' as logger_pkg;

import '../env/env_config.dart';

class AppLogger {
  AppLogger._();

  static final logger_pkg.Logger _logger = logger_pkg.Logger(
    printer: logger_pkg.PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
    ),
    level: EnvConfig.isProd ? logger_pkg.Level.warning : logger_pkg.Level.debug,
  );

  static void debug(String message, {String? tag}) {
    _logger.d(_format(message, tag));
  }

  static void info(String message, {String? tag}) {
    _logger.i(_format(message, tag));
  }

  static void warning(String message, {String? tag, Object? error}) {
    _logger.w(_format(message, tag), error: error);
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(_format(message, tag), error: error, stackTrace: stackTrace);
  }

  static String _format(String message, String? tag) {
    return tag != null ? '[$tag] $message' : message;
  }
}
