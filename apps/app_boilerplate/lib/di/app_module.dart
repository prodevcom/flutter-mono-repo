import 'package:injectable/injectable.dart';

/// App-specific overrides and additional bindings.
/// Use @module classes here to override defaults from micro-packages.
///
/// Example:
/// ```dart
/// @module
/// abstract class AppOverrides {
///   @lazySingleton
///   SomeService get someService => CustomSomeService();
/// }
/// ```
@module
abstract class AppModule {
  // Add app-specific overrides here
}
