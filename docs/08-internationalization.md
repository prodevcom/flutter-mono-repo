# 08 - Internationalization (i18n)

MonoApp uses Flutter's built-in `intl` + `gen-l10n` system. Each package that has UI generates its own localizations from ARB files.

## Strategy

Each package with UI maintains its own translations:

| Package | Class | Strings |
|---|---|---|
| `design_system` | `DsLocalizations` | Generic: "Cancel", "OK", "Save", "Close", "Loading" |
| `auth_flow` | `AuthLocalizations` | Auth: "Email", "Password", "Login", "Register" |
| `home_flow` | `HomeLocalizations` | Home: "Home", "No items", "Retry" |
| `onboarding` | `OnboardingLocalizations` | Onboarding: step titles, "Skip", "Next", "Get Started" |
| `profile_flow` | `ProfileLocalizations` | Profile: "Profile", "Edit Profile", "Save" |
| App | `AppLocalizations` | App-level: app name, welcome message |

## How It Works

### 1. `l10n.yaml` per Package

Each package with ARB files has a `l10n.yaml`:

```yaml
# packages/features/auth_flow/l10n.yaml
arb-dir: lib/src/l10n
template-arb-file: auth_en.arb
output-localization-file: auth_localizations.dart
output-class: AuthLocalizations
synthetic-package: false
output-dir: lib/src/l10n/generated
```

### 2. ARB Files

```json
// packages/features/auth_flow/lib/src/l10n/auth_en.arb
{
  "loginTitle": "Login",
  "email": "Email",
  "emailHint": "Enter your email",
  "password": "Password",
  "login": "Login",
  "register": "Register"
}
```

```json
// packages/features/auth_flow/lib/src/l10n/auth_pt.arb
{
  "loginTitle": "Entrar",
  "email": "Email",
  "emailHint": "Digite seu email",
  "password": "Senha",
  "login": "Entrar",
  "register": "Cadastrar"
}
```

### 3. App Composes All Delegates

```dart
// apps/app_boilerplate/lib/app.dart
MaterialApp.router(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    DsLocalizations.delegate,
    AuthLocalizations.delegate,
    HomeLocalizations.delegate,
    OnboardingLocalizations.delegate,
    ProfileLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
)
```

### 4. Usage in Widgets

```dart
final l10n = AuthLocalizations.of(context)!;
Text(l10n.loginTitle);
```

## Generating Localizations

```bash
# Generate for all packages
make l10n

# Generate for a single package
cd packages/features/auth_flow && flutter gen-l10n
```

## Adding a New Language

1. Create ARB files for the new language in each package:

```
auth_es.arb    # Spanish
auth_fr.arb    # French
```

2. Add the locale to the app's ARB file (the template sets supported locales).

3. Regenerate:

```bash
make l10n
```

## Adding Translations to a New Feature

1. Create `l10n.yaml` in the feature package root
2. Create `lib/src/l10n/<feature>_en.arb` (template) + other languages
3. Add `flutter: generate: true` in `pubspec.yaml`
4. Run `flutter gen-l10n` or `make l10n`
5. Export the generated localizations in the barrel file
6. Add the delegate to `app.dart`

## Client App Translation Overrides

Client apps have their own `lib/l10n/` directory with app-level ARB files. They can:

- Use the same translations as the boilerplate
- Override app-level strings (app name, welcome messages)
- Add languages that the boilerplate doesn't support

Feature translations (auth, home, etc.) are shared across all apps.
