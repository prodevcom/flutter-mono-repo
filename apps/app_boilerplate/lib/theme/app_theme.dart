import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// App-specific theme overrides.
/// Extend or override the base design system theme here.
///
/// Example usage for client apps:
/// ```dart
/// class ClientTheme {
///   static ThemeData get light => AppTheme.light.copyWith(
///     colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
///   );
/// }
/// ```
class BoilerplateTheme {
  BoilerplateTheme._();

  static ThemeData get light => AppTheme.light;
  static ThemeData get dark => AppTheme.dark;
}
