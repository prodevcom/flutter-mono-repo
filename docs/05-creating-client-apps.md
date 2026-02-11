# 05 - Creating Client Apps

Client apps are white-label instances generated from the `app_boilerplate`. Each client gets its own branding, theme, translations, and configuration.

## Generating a New Client App

### Using the Makefile

```bash
make create-app NAME=client_acme DISPLAY="Acme Corp" BUNDLE=com.acme.app
```

### Using the Script Directly

```bash
./scripts/create_app.sh \
  --name "client_acme" \
  --display-name "Acme Corp" \
  --bundle-id "com.acme.app"
```

## What the Script Does

1. **Copies** `apps/app_boilerplate/` to `apps/client_acme/`
2. **Cleans** generated files (`.dart_tool`, `build`, `*.g.dart`, etc.)
3. **Updates** `pubspec.yaml` with the new app name
4. **Updates** Android bundle IDs and package paths
5. **Updates** iOS bundle IDs and Info.plist
6. **Creates** a theme customization file
7. **Creates** environment config files (`env/dev.json`, `env/stg.json`, `env/prod.json`)
8. **Adds** the new app to the root workspace
9. **Updates** Dart imports to the new package name

## Post-Generation Steps

```bash
# 1. Resolve dependencies
make bootstrap

# 2. Generate code
make gen

# 3. Generate localizations
make l10n

# 4. Run the new app
cd apps/client_acme && flutter run --dart-define-from-file=env/dev.json
```

## Customizing the Client App

### Theme

Edit `apps/client_acme/lib/theme/app_theme.dart` to override colors, fonts, and component styles:

```dart
class ClientAcmeTheme {
  ClientAcmeTheme._();

  static ThemeData get light => AppTheme.light.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),  // Acme brand green
          brightness: Brightness.light,
        ),
      );

  static ThemeData get dark => AppTheme.dark.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.dark,
        ),
      );
}
```

Then update `app.dart` to use `ClientAcmeTheme.light` / `.dark`.

### Translations

Override translations in `apps/client_acme/lib/l10n/`:

```json
// app_en.arb
{
  "appName": "Acme Corp",
  "welcomeMessage": "Welcome to Acme"
}
```

### Environment Config

Update `apps/client_acme/env/`:

```json
// prod.json
{
  "FLAVOR": "prod",
  "APP_NAME": "Acme Corp",
  "BASE_URL": "https://api.acme.com/v1"
}
```

### Selective Features

A client app can exclude features by:

1. Removing the feature dependency from `pubspec.yaml`
2. Removing the route from `app_router.dart`
3. Removing the DI module from `injection.dart`
4. Removing the localization delegate from `app.dart`

## Adding Launch Configurations

Add to `.vscode/launch.json`:

```json
{
  "name": "Acme (Dev)",
  "request": "launch",
  "type": "dart",
  "cwd": "${workspaceFolder}/apps/client_acme",
  "program": "lib/main_dev.dart",
  "args": ["--dart-define-from-file=${workspaceFolder}/apps/client_acme/env/dev.json"]
}
```

## Adding Makefile Commands

Add to the Makefile:

```makefile
run-acme-dev: ## Run client_acme with dev flavor
	@cd apps/client_acme && flutter run --dart-define-from-file=env/dev.json
```
