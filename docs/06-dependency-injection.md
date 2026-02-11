# 06 - Dependency Injection

MonoApp uses **GetIt** as the service locator and **Injectable** for code generation. Each package defines its own DI micro-package, and apps compose them at startup.

## How It Works

### 1. Micro-Packages

Each package (core, shared, modules, features) has a DI file with `@InjectableInit.microPackage()`:

```dart
// packages/modules/auth/lib/src/di/auth_module_di.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit.microPackage()
void initAuthModulePackageModule(GetIt getIt) {}
```

Running `build_runner` generates `auth_module_di.module.dart` which contains an `AuthModulePackageModule` class that registers all annotated classes in that package.

### 2. App Composition

The app wires all micro-packages together:

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
Future<void> configureDependencies(String environment) async =>
    getIt.init(environment: environment);
```

### 3. Initialization

Each `main_*.dart` calls `configureDependencies` with the environment name:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies('dev');  // or 'stg', 'prod'
  runApp(const App());
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

### Example: Environment-Specific Data Sources

```dart
// Real implementation — used in prod and stg
@prod
@Environment('stg')
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiClient);
  final ApiClient _apiClient;
  // ... real API calls
}

// Fake implementation — used in dev
@dev
@LazySingleton(as: AuthRemoteDataSource)
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  // ... in-memory fake data
}
```

The generated `.module.dart` will register the correct implementation based on the environment string passed to `configureDependencies()`.

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

@InjectableInit.microPackage()
void initNewModulePackageModule(GetIt getIt) {}
```

2. Export it in the barrel file:

```dart
export 'src/di/new_module_di.dart';
export 'src/di/new_module_di.module.dart';
```

3. Run `build_runner` to generate the `.module.dart`

4. Add it to the app's `injection.dart`:

```dart
ExternalModule(NewModulePackageModule),
```

5. Rebuild the app:

```bash
cd apps/app_boilerplate && dart run build_runner build --delete-conflicting-outputs
```

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
