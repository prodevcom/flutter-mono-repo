import 'package:injectable/injectable.dart';

abstract class CrashReportingService {
  Future<void> recordError(dynamic exception, StackTrace? stackTrace);
  Future<void> setUserId(String? userId);
  Future<void> log(String message);
}

@LazySingleton(as: CrashReportingService)
class CrashReportingServiceImpl implements CrashReportingService {
  @override
  Future<void> recordError(dynamic exception, StackTrace? stackTrace) async {
    // TODO: Implement with Firebase Crashlytics or Sentry
  }

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> log(String message) async {}
}
