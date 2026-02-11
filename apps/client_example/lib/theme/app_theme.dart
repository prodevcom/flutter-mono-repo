import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Client Example theme - demonstrates overriding the base theme.
class ClientExampleTheme {
  ClientExampleTheme._();

  /// Override with a teal color scheme for this client
  static ThemeData get light => AppTheme.light.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get dark => AppTheme.dark.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      );
}
