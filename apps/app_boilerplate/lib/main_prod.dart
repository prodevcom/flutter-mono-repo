import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'di/injection.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      AppLogger.error(
        details.exceptionAsString(),
        tag: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    await configureDependencies('prod');
    runApp(const App());
  }, (error, stack) {
    AppLogger.error(
      'Uncaught error',
      tag: 'Zone',
      error: error,
      stackTrace: stack,
    );
  });
}
