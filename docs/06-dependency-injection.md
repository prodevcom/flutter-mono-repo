# 06 - Dependency Injection

MonoApp uses **GetIt** as the service locator and **Injectable** for code generation. Each package defines its own DI micro-package, and apps compose them at startup.

## How It Works

### 1. Micro-Packages

Each package (core, shared, modules, features) has a DI file with `@InjectableInit.microPackage()`:

```dart
// packages/modules/auth/lib/src/di/auth_module_di.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage(ignoreUnregisteredTypesInPackages: ['package:core'])
void initAuthModulePackageModule(GetIt getIt) {}
```

Running `build_runner` generates `auth_module_di.module.dart` which contains an `AuthModulePackageModule` class that registers all annotated classes in that package.

### 2. App Composition

The app wires all micro-packages together and registers dev overrides:

```dart
// apps/app_boilerplate/lib/di/injection.dart
final getIt = GetIt.instance;

@InjectableInit(
  externalPackageModulesBefore: [
    ExternalModule(CorePackageModule),
    ExternalModule(SharedPackageModule),
    ExternalModule(AuthModulePackageModule),
    ExternalModule(HomeModulePackageModule),
    ExternalModule(UserProfileModulePackageModule),
    ExternalModule(AuthFlowPackageModule),
    ExternalModule(HomeFlowPackageModule),
    ExternalModule(OnboardingPackageModule),
    ExternalModule(ProfileFlowPackageModule),
  ],
)
Future<void> configureDependencies(String environment) async {
  await getIt.init(environment: environment);

  if (environment == 'dev') {
    _registerDevOverrides();
  }
}

void _registerDevOverrides() {
  getIt.allowReassignment = true;
  getIt.registerLazySingleton<AuthRemoteDataSource>(() => FakeAuthRemoteDataSource());
  getIt.registerLazySingleton<AuthLocalDataSource>(() => FakeAuthLocalDataSource());
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => FakeHomeRemoteDataSource());
  getIt.registerLazySingleton<ProfileRemoteDataSource>(() => FakeProfileRemoteDataSource());
  getIt.allowReassignment = false;
}
```

### 3. Initialization

Each `main_*.dart` calls `configureDependencies` inside `runZonedGuarded` with structured error logging:

```dart
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

    await configureDependencies('dev');  // or 'stg', 'prod'
    runApp(const App());
  }, (error, stack) {
    AppLogger.error('Uncaught error', tag: 'Zone', error: error, stackTrace: stack);
  });
}
```

## Environments

Injectable supports environment-based registration. MonoApp uses three environments:

| Environment | Annotation | Data Sources | Use Case |
|---|---|---|---|
| `dev` | `@dev` | Fake (in-memory) | Local development without API |
| `stg` | `@Environment('stg')` | Real (API) | Staging testing |
| `prod` | `@prod` | Real (API) | Production |

> **Note:** `@dev`, `@prod`, and `@test` are built-in Injectable constants. For custom environments like `stg`, use `@Environment('stg')`.

### Environment-Specific Data Sources (Current Pattern)

Real implementations use `@LazySingleton` with **no environment annotation** — they register for all environments via injectable. Fake implementations are **plain Dart classes** with no DI annotations — they are registered manually in the app's `injection.dart` only when `environment == 'dev'`.

```dart
// Real implementation — registered by injectable for all environments
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;
  // ... real API calls
}

// Fake implementation — NO DI annotations, registered manually in dev
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  // ... in-memory fake data
}
```

#### Why manual registration instead of `@dev`?

`injectable_generator` processes files alphabetically. Since fake files (`auth_fake_*`) sort before real files (`auth_remote_*`), the generated `.module.dart` registers the fake **first** and the real **second**. With `allowReassignment`, the last write wins — meaning the real implementation always overwrites the fake, even in dev. Manual registration after `getIt.init()` guarantees fakes always win in dev, regardless of generator ordering.

#### Why not use `@prod @Environment('stg')` on the real implementations?

`injectable_generator` 2.x has a known bug in `_sortByDependents` that causes a **Stack Overflow** when environment annotations are combined (`@prod @Environment('stg')`) on classes that depend on types from other packages. Manual registration avoids this entirely.

### `ignoreUnregisteredTypesInPackages`

Micro-packages that depend on types from other packages (e.g., `ApiClient` from `core`) use this option to suppress "Missing dependencies" warnings during code generation:

```dart
@InjectableInit.microPackage(ignoreUnregisteredTypesInPackages: ['package:core'])
void initAuthModulePackageModule(GetIt getIt) {}
```

Feature packages that depend on types from both `core` and `shared` list both:

```dart
@InjectableInit.microPackage(ignoreUnregisteredTypesInPackages: ['package:core', 'package:shared'])
void initAuthFlowPackageModule(GetIt getIt) {}
```

These warnings are expected in a micro-package architecture and do not indicate an error — the types will be available at runtime because the app composes all modules in the correct order via `externalPackageModulesBefore`.

## Annotations Reference

| Annotation | Scope | Description |
|---|---|---|
| `@injectable` | Transient | New instance every time |
| `@lazySingleton` | Lazy singleton | Created on first access |
| `@singleton` | Eager singleton | Created at init time |
| `@LazySingleton(as: Interface)` | Lazy singleton | Registers as interface type |
| `@dev` | Environment | Only registered in dev |
| `@prod` | Environment | Only registered in prod |
| `@test` | Environment | Only registered in test |
| `@Environment('stg')` | Environment | Only registered in stg |

## Adding a New Package to DI

1. Create the DI file in the package:

```dart
// packages/modules/new_module/lib/src/di/new_module_di.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage(ignoreUnregisteredTypesInPackages: ['package:core'])
void initNewModulePackageModule(GetIt getIt) {}
```

2. Export it in the barrel file:

```dart
export 'src/di/new_module_di.dart';
export 'src/di/new_module_di.module.dart';
```

3. Run `build_runner` to generate the `.module.dart`:

```bash
make gen
```

4. Add it to the app's `injection.dart`:

```dart
ExternalModule(NewModulePackageModule),
```

5. Rebuild the app:

```bash
make gen
```

> **Note:** You no longer need to edit the Makefile when adding new packages — `make gen` delegates to melos, which auto-discovers packages via `packageFilters`.

## Accessing Dependencies

```dart
// In pages/widgets (via GetIt directly)
final cubit = GetIt.I<HomeCubit>();

// In BlocProvider
BlocProvider(
  create: (_) => GetIt.I<HomeCubit>()..loadItems(),
  child: ...
)
```
