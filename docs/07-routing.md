# 07 - Routing

MonoApp uses **auto_route v11** for type-safe, declarative routing. Each feature generates its own route classes, and the app composes them in a single router.

## Architecture

```
Feature Package                    App
┌─────────────────────┐     ┌──────────────────────┐
│ @RoutePage()        │     │ @AutoRouterConfig()   │
│ class HomePage      │────→│ class AppRouter       │
│                     │     │   routes: [           │
│ generates:          │     │     HomeRoute.page,   │
│   HomeRoute.page    │     │     LoginRoute.page,  │
│                     │     │     ...               │
└─────────────────────┘     └──────────────────────┘
```

## Route Path Constants

All route paths are centralized in `core` to avoid hardcoded strings:

```dart
// packages/core/lib/src/navigation/app_routes.dart
abstract final class AppRoutes {
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
}
```

## How Features Define Routes

Each feature has a router file with `@AutoRouterConfig()`:

```dart
// packages/features/home_flow/lib/src/routes/home_routes.dart
import 'package:auto_route/auto_route.dart';
import '../presentation/pages/home_page.dart';

part 'home_routes.gr.dart';

@AutoRouterConfig()
class HomeFlowRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page),
      ];
}
```

The `@RoutePage()` annotation on the page class generates the `HomeRoute` class:

```dart
@RoutePage()
class HomePage extends StatelessWidget { ... }
```

## How the App Composes Routes

The app router imports all features and defines the complete route tree:

```dart
// apps/app_boilerplate/lib/app_router.dart
import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:auth_flow/auth_flow.dart';
import 'package:home_flow/home_flow.dart';
import 'package:onboarding/onboarding.dart';
import 'package:profile_flow/profile_flow.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: AppRoutes.home, initial: true),
        AutoRoute(page: LoginRoute.page, path: AppRoutes.login),
        AutoRoute(page: RegisterRoute.page, path: AppRoutes.register),
        AutoRoute(page: OnboardingRoute.page, path: AppRoutes.onboarding),
        AutoRoute(page: ProfileRoute.page, path: AppRoutes.profile),
        AutoRoute(page: EditProfileRoute.page, path: AppRoutes.editProfile),
      ];
}
```

## Navigation in Features

Since features don't depend on each other, they navigate using path-based navigation with `AppRoutes` constants:

```dart
// Navigate to a route
context.router.pushPath(AppRoutes.profile);

// Go back
context.router.maybePop();

// Replace current route
context.router.replacePath(AppRoutes.home);
```

### Available Navigation Methods

| Method | Description |
|---|---|
| `context.router.pushPath('/path')` | Push a new route by path |
| `context.router.replacePath('/path')` | Replace current route by path |
| `context.router.maybePop()` | Pop if possible |
| `context.router.popUntilRoot()` | Pop all routes to root |

## Adding a New Route

1. **Add the path** to `AppRoutes` in core:

```dart
static const orders = '/orders';
```

2. **Create the page** with `@RoutePage()` in the feature:

```dart
@RoutePage()
class OrdersPage extends StatelessWidget { ... }
```

3. **Create/update the feature router**:

```dart
@AutoRouterConfig()
class OrdersFlowRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: OrdersRoute.page),
      ];
}
```

4. **Add the route** to `app_router.dart`:

```dart
AutoRoute(page: OrdersRoute.page, path: AppRoutes.orders),
```

5. **Regenerate**:

```bash
make gen
```

## Route Guards (Future)

auto_route supports guards for authentication, onboarding checks, etc.:

```dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: AppRoutes.home, initial: true, guards: [AuthGuard]),
      ];
}
```
