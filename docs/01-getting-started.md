# 01 - Getting Started

## Prerequisites

| Tool | Version | Install |
|---|---|---|
| Flutter SDK | 3.38+ | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.10+ | Included with Flutter |
| Melos | 7+ | `dart pub global activate melos` |
| Xcode | 16+ | App Store (macOS, for iOS builds) |
| Android Studio | Latest | [developer.android.com](https://developer.android.com/studio) |

## First-Time Setup

### 1. Clone the Repository

```bash
git clone git@github.com:prodevcom/flutter-mono-repo.git
cd flutter-mono-repo
```

### 2. Run Setup

```bash
make setup
```

This single command will:
1. Install Melos globally
2. Resolve all workspace dependencies (`flutter pub get`)
3. Run `build_runner` in all packages (generates Freezed models, injectable DI, auto_route, JSON serialization)
4. Generate localization files (`flutter gen-l10n`)

### 3. Run the App

```bash
# Terminal
make run-boilerplate-dev

# Or via VS Code: F5 → select "Boilerplate (Dev)"
```

The **dev** flavor uses fake data sources, so no backend API is needed.

## Project Overview

```
MonoApp/
├── apps/                   # Runnable Flutter applications
├── packages/
│   ├── core/               # Foundation (all packages depend on this)
│   ├── design_system/      # UI components
│   ├── shared/             # Cross-cutting concerns
│   ├── modules/            # Business logic (no UI)
│   └── features/           # UI + presentation
├── scripts/                # Automation scripts
├── Makefile                # Developer commands
└── melos.yaml              # Workspace configuration
```

## Day-to-Day Workflow

### After Pulling Changes

```bash
make bootstrap   # Resolve dependencies
make gen         # Regenerate code
make l10n        # Regenerate localizations
```

### After Modifying a Freezed Model or DTO

```bash
make gen
```

### After Modifying an ARB Translation File

```bash
make l10n
```

### Before Pushing

```bash
make ci          # Runs analyze + format check + test
```

## Troubleshooting

### "Could not resolve..." dependency errors

```bash
make bootstrap
```

### Generated files are out of date or corrupted

```bash
make gen-clean   # Cleans caches and regenerates everything
```

### Everything is broken

```bash
make clean-all   # Nuclear option: removes ALL generated files
make setup       # Rebuild from scratch
```

## Next Steps

- [02 - Architecture](02-architecture.md) — Understand the project structure
- [06 - Dependency Injection](06-dependency-injection.md) — How DI and environments work
- [07 - Routing](07-routing.md) — How navigation works across features
