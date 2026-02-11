# MonoApp

A scalable Flutter monorepo supporting **multi-app (white-label)**, **multi-flavor (dev/stg/prod)**, and **shared packages** with clean architecture.

The `app_boilerplate` serves as the base for all development. Client apps are generated from it via a shell script with custom branding, config, and translations.

## Tech Stack

| Category | Tool | Version |
|---|---|---|
| Framework | Flutter | 3.38+ |
| Monorepo | Melos | 7+ |
| Routing | auto_route | 11 |
| DI | get_it + injectable | 8 / 2.5 |
| State | Bloc / Cubit | 9.1 |
| Serialization | Freezed + json_serializable | 3.0 / 6.9 |
| Network | Dio | 5.8 |
| i18n | intl + gen-l10n | 0.20 |

## Project Structure

```
MonoApp/
├── apps/
│   ├── app_boilerplate/        # Base app - all development happens here
│   └── client_example/         # Example client app with custom theme
├── packages/
│   ├── core/                   # Foundation: networking, storage, env, base classes
│   ├── design_system/          # Tokens, theme, widgets, i18n
│   ├── shared/                 # Analytics, crash reporting, connectivity
│   ├── modules/                # Domain: business logic + data (NO UI)
│   │   ├── auth/
│   │   ├── home/
│   │   └── user_profile/
│   └── features/               # UI: routes, blocs, pages, widgets, i18n
│       ├── auth_flow/
│       ├── home_flow/
│       ├── onboarding/
│       └── profile_flow/
├── scripts/
│   └── create_app.sh           # Generate new client apps
├── Makefile                    # Developer commands
└── melos.yaml                  # Melos workspace config
```

## Quick Start

### Prerequisites

- Flutter SDK 3.38+
- Dart SDK 3.10+
- Melos (`dart pub global activate melos`)

### First Run

```bash
make setup
```

This will install dependencies, run code generation, and generate localizations.

### Run the App

```bash
# Run boilerplate app (dev flavor, uses fake data - no API needed)
make run-boilerplate-dev

# Run client example (dev flavor)
make run-client-dev
```

### VS Code

Open the project in VS Code and use the pre-configured launch configurations in `.vscode/launch.json`. Press F5 and select the desired app + flavor.

## Common Commands

| Command | Description |
|---|---|
| `make setup` | First-time setup (install + bootstrap + gen + l10n) |
| `make gen` | Run build_runner in all packages (sequential) |
| `make gen-clean` | Clean caches and regenerate everything |
| `make l10n` | Generate localization files |
| `make analyze` | Run dart analyze |
| `make test` | Run all tests |
| `make ci` | Full CI pipeline (analyze + format check + test) |
| `make clean` | Flutter clean all packages |
| `make clean-all` | Deep clean (remove all generated code) |
| `make help` | Show all available commands |

## Creating a New Client App

```bash
make create-app NAME=client_acme DISPLAY="Acme Corp" BUNDLE=com.acme.app
```

See [docs/05-creating-client-apps.md](docs/05-creating-client-apps.md) for details.

## Flavors

Each app supports three flavors configured via `--dart-define-from-file`:

| Flavor | Entry Point | Config | DI Environment |
|---|---|---|---|
| **dev** | `main_dev.dart` | `env/dev.json` | Fake data sources (no API) |
| **stg** | `main_stg.dart` | `env/stg.json` | Real data sources |
| **prod** | `main_prod.dart` | `env/prod.json` | Real data sources |

## Architecture

```
          apps/app_boilerplate · apps/client_*
             /      |       \
      features/*  design_system  shared
         |    \       |           |
     modules/*  \   core        core
         |       |
       core    core
```

**Rules:**
- Modules never depend on features
- Features never depend on other features
- Apps compose features selectively

See [docs/02-architecture.md](docs/02-architecture.md) for the full architecture guide.

## Documentation

| Guide | Description |
|---|---|
| [01 - Getting Started](docs/01-getting-started.md) | Setup, prerequisites, first run |
| [02 - Architecture](docs/02-architecture.md) | Clean architecture, layers, dependency graph |
| [03 - Creating Modules](docs/03-creating-modules.md) | Step-by-step guide to create a new domain module |
| [04 - Creating Features](docs/04-creating-features.md) | Step-by-step guide to create a new feature |
| [05 - Creating Client Apps](docs/05-creating-client-apps.md) | White-label app generation |
| [06 - Dependency Injection](docs/06-dependency-injection.md) | DI setup, environments, micro-packages |
| [07 - Routing](docs/07-routing.md) | Auto route, AppRoutes, navigation patterns |
| [08 - Internationalization](docs/08-internationalization.md) | i18n with intl + ARB files |
| [09 - Theming](docs/09-theming.md) | Design system, client theme overrides |

## Contributing

Pull requests with improvements are welcome! Whether it's a bug fix, a new feature template, better docs, or performance improvements — all contributions help the community.

The goal of this project is to **help the Flutter community scale SaaS ideas for everyone**. A solid, open architecture shouldn't be a competitive advantage locked behind closed doors — it should be a starting point anyone can build on.

If you have ideas, open an issue or submit a PR.

## License

This project is licensed under the [MIT License](LICENSE).

## Author

**Marcelo Mussi** — [ProDev](https://github.com/prodevcom)

Built with Flutter and a passion for scalable architecture.
