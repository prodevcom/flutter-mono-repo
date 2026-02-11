# 02 - Architecture

## Overview

MonoApp follows **Clean Architecture** with a strict layer separation. The codebase is split into independent packages, each with a single responsibility.

## Layers

```
┌─────────────────────────────────────────────┐
│                    APPS                      │  Composition root: DI, routing, theming
│         app_boilerplate · client_*           │
├─────────────────────────────────────────────┤
│                  FEATURES                    │  UI: pages, widgets, blocs, routes, i18n
│   auth_flow · home_flow · onboarding · ...   │
├─────────────────────────────────────────────┤
│                  MODULES                     │  Domain: entities, repos, use cases, data
│        auth · home · user_profile            │
├─────────────────────────────────────────────┤
│           DESIGN SYSTEM · SHARED             │  UI components · cross-cutting services
├─────────────────────────────────────────────┤
│                    CORE                      │  Foundation: networking, storage, env, base
└─────────────────────────────────────────────┘
```

## Package Types

### Core (`packages/core/`)

Foundation package that all others depend on.

| Directory | Contents |
|---|---|
| `src/env/` | `EnvConfig`, `Flavor` enum |
| `src/network/` | `ApiClient` (Dio), interceptors, exceptions |
| `src/storage/` | `LocalStorage`, `SecureStorage` abstractions |
| `src/logger/` | `AppLogger` |
| `src/base/` | `UseCase<I,O>`, `Result<T>`, `Failure` |
| `src/navigation/` | `AppRoutes` (centralized route paths) |
| `src/extensions/` | String, Context, Date extensions |
| `src/di/` | Core DI micro-package |

### Design System (`packages/design_system/`)

UI tokens, theme, reusable widgets, and generic i18n strings.

| Directory | Contents |
|---|---|
| `src/tokens/` | `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius` |
| `src/theme/` | `AppTheme` (factory), `AppThemeData` (abstract) |
| `src/widgets/` | `DsButton`, `DsTextField`, `DsCard`, `DsLoading` |
| `src/l10n/` | ARB files + generated localizations (`DsLocalizations`) |

### Modules (`packages/modules/*/`)

Business logic and data — **no UI**. Each module follows clean architecture:

```
module/
├── domain/
│   ├── entities/       # Freezed value objects (e.g., User, HomeItem)
│   ├── repositories/   # Abstract repository interfaces
│   └── use_cases/      # Single-purpose business operations
├── data/
│   ├── dtos/           # Freezed + json_serializable data transfer objects
│   ├── data_sources/   # Remote (API) + Local (cache) + Fake (dev)
│   └── repositories/   # Repository implementations
└── di/                 # Injectable micro-package config
```

### Features (`packages/features/*/`)

UI presentation — pages, widgets, blocs, routes, i18n. Each feature maps to one or more modules:

```
feature/
├── presentation/
│   ├── bloc/           # Cubit/Bloc state management
│   ├── pages/          # @RoutePage() annotated screens
│   └── widgets/        # Feature-specific widgets
├── routes/             # @AutoRouterConfig() + RootStackRouter
├── l10n/               # ARB files + generated localizations
└── di/                 # Injectable micro-package config
```

### Apps (`apps/*/`)

Composition root that wires everything together:

```
app/
├── lib/
│   ├── main_dev.dart   # Entry point (dev flavor)
│   ├── main_stg.dart   # Entry point (stg flavor)
│   ├── main_prod.dart  # Entry point (prod flavor)
│   ├── app.dart        # MaterialApp.router + localization delegates
│   ├── app_router.dart # Composes routes from all features
│   ├── di/
│   │   └── injection.dart  # Wires all DI micro-packages
│   ├── theme/
│   │   └── app_theme.dart  # App-specific theme (can override design system)
│   └── l10n/               # App-level ARB files
├── env/
│   ├── dev.json
│   ├── stg.json
│   └── prod.json
├── android/
└── ios/
```

## Dependency Graph

```
          apps/app_boilerplate · apps/client_*
             /      |       \
      features/*  design_system  shared
         |    \       |           |
     modules/*  \   core        core
         |       |
       core    core
```

## Dependency Rules

| Rule | Description |
|---|---|
| Modules never depend on features | Domain logic is UI-agnostic |
| Features never depend on other features | Features are independent and composable |
| Features depend on their module(s) + core + design_system | Each feature imports its corresponding module |
| Apps compose features selectively | A client app can include/exclude features |
| Everything depends on core | Core is the foundation |

## Modules vs Features

| | Modules | Features |
|---|---|---|
| **Contains** | Entities, Repositories, UseCases, DataSources, DTOs | Pages, Widgets, Blocs/Cubits, Routes, i18n |
| **UI** | None | All UI |
| **Dependencies** | `core` only | `core` + `design_system` + module(s) |
| **Testability** | Pure unit tests | Widget tests + bloc tests |
| **Purpose** | Reusable across features and apps | Consumable presentation for apps |

## Data Flow

```
UI (Page) → Bloc/Cubit → UseCase → Repository → DataSource → API/Cache
     ↑                                    ↑
  Feature                              Module
```

1. **Page** dispatches an event or calls a cubit method
2. **Cubit** calls a `UseCase`
3. **UseCase** calls a `Repository` (abstract interface)
4. **RepositoryImpl** calls a `DataSource` (remote or local)
5. **DataSource** makes the actual API call or cache read
6. Data flows back as `Result<T>` (success or failure)
