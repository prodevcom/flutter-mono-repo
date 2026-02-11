# 09 - Theming

MonoApp has a two-layer theming system: a **Design System** base theme and **per-app overrides**.

## Design System Theme

The base theme lives in `packages/design_system/`:

```
design_system/lib/src/
├── tokens/
│   ├── app_colors.dart      # Color palette
│   ├── app_typography.dart   # Text styles
│   ├── app_spacing.dart      # Spacing constants (xs, sm, md, lg, xl, xxl)
│   └── app_radius.dart       # Border radius constants
├── theme/
│   ├── app_theme.dart        # ThemeData factory (light + dark)
│   └── app_theme_data.dart   # Abstract theme contract
└── widgets/
    ├── ds_button.dart        # DsButton (primary, secondary, outlined, text)
    ├── ds_text_field.dart    # DsTextField
    ├── ds_card.dart          # DsCard
    └── ds_loading.dart       # DsLoading
```

### Using Design Tokens

```dart
import 'package:design_system/design_system.dart';

// Spacing
Padding(padding: const EdgeInsets.all(AppSpacing.md))

// Colors
AppColors.primary

// Theme data
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.headlineMedium
```

## App Theme Overrides

### Boilerplate (Default)

Uses the design system theme directly:

```dart
// apps/app_boilerplate/lib/theme/app_theme.dart
class BoilerplateTheme {
  static ThemeData get light => AppTheme.light;
  static ThemeData get dark => AppTheme.dark;
}
```

### Client Example (Custom)

Demonstrates a completely different look using deep purple:

```dart
// apps/client_example/lib/theme/app_theme.dart
class ClientExampleTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C4DFF),
      primary: const Color(0xFF6200EA),
      secondary: const Color(0xFF00BFA5),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF5F0FF),
      // ... custom component themes
    );
  }
}
```

## Creating a Client Theme

### Method 1: Extend the Base Theme

```dart
class ClientTheme {
  static ThemeData get light => AppTheme.light.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get dark => AppTheme.dark.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      );
}
```

### Method 2: Build from Scratch

```dart
class ClientTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B00)),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Color(0xFFFF6B00),
          foregroundColor: Colors.white,
        ),
        // ... full custom theme
      );
}
```

### Applying the Theme

```dart
// apps/client_acme/lib/app.dart
MaterialApp.router(
  theme: ClientAcmeTheme.light,
  darkTheme: ClientAcmeTheme.dark,
  themeMode: ThemeMode.system,
)
```

## Component Theming

Design system widgets use `Theme.of(context)` and adapt to any theme automatically. The `DsButton` for example uses `ElevatedButton`, `FilledButton.tonal`, `OutlinedButton`, or `TextButton` which all respect the app's `ThemeData`.

If you need a component to look different per client, override the relevant `ThemeData` component theme:

```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
),
```

> **Tip:** The boilerplate uses `borderRadius: 8` and `buttonHeight: 48`. The client_example uses `borderRadius: 16` and `buttonHeight: 52` to show the visual difference.
