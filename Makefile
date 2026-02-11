.PHONY: setup bootstrap gen l10n analyze test format clean all run-boilerplate-dev run-boilerplate-stg run-client-dev run-client-stg ci help

# ============================================================================
# MonoApp - Developer Makefile
# ============================================================================

## Setup & Bootstrap --------------------------------------------------------

setup: ## First-time setup: install tools and bootstrap
	@echo "=> Installing Melos globally..."
	dart pub global activate melos
	@echo "=> Bootstrapping workspace..."
	flutter pub get
	@$(MAKE) gen
	@$(MAKE) l10n
	@echo "=> Done! Run 'make run-boilerplate-dev' to start the app."

bootstrap: ## Resolve all workspace dependencies
	flutter pub get

## Code Generation ----------------------------------------------------------

gen: ## Run build_runner in all packages (sequential to avoid conflicts)
	@echo "=> Running build_runner in core..."
	@cd packages/core && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in shared..."
	@cd packages/shared && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in modules/auth..."
	@cd packages/modules/auth && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in modules/home..."
	@cd packages/modules/home && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in modules/user_profile..."
	@cd packages/modules/user_profile && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in features/auth_flow..."
	@cd packages/features/auth_flow && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in features/home_flow..."
	@cd packages/features/home_flow && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in features/onboarding..."
	@cd packages/features/onboarding && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in features/profile_flow..."
	@cd packages/features/profile_flow && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in apps/app_boilerplate..."
	@cd apps/app_boilerplate && dart run build_runner build --delete-conflicting-outputs
	@echo "=> Running build_runner in apps/client_example..."
	@cd apps/client_example && dart run build_runner build --delete-conflicting-outputs
	@echo "=> All build_runner tasks complete."

gen-clean: ## Clean build_runner cache and regenerate everything
	@echo "=> Cleaning build_runner caches..."
	@cd packages/core && dart run build_runner clean 2>/dev/null || true
	@cd packages/shared && dart run build_runner clean 2>/dev/null || true
	@cd packages/modules/auth && dart run build_runner clean 2>/dev/null || true
	@cd packages/modules/home && dart run build_runner clean 2>/dev/null || true
	@cd packages/modules/user_profile && dart run build_runner clean 2>/dev/null || true
	@cd packages/features/auth_flow && dart run build_runner clean 2>/dev/null || true
	@cd packages/features/home_flow && dart run build_runner clean 2>/dev/null || true
	@cd packages/features/onboarding && dart run build_runner clean 2>/dev/null || true
	@cd packages/features/profile_flow && dart run build_runner clean 2>/dev/null || true
	@cd apps/app_boilerplate && dart run build_runner clean 2>/dev/null || true
	@cd apps/client_example && dart run build_runner clean 2>/dev/null || true
	@$(MAKE) gen

l10n: ## Generate localization files for all packages
	@echo "=> Generating localizations..."
	@cd packages/design_system && flutter gen-l10n
	@cd packages/features/auth_flow && flutter gen-l10n
	@cd packages/features/home_flow && flutter gen-l10n
	@cd packages/features/onboarding && flutter gen-l10n
	@cd packages/features/profile_flow && flutter gen-l10n
	@cd apps/app_boilerplate && flutter gen-l10n
	@cd apps/client_example && flutter gen-l10n
	@echo "=> Localizations generated."

## Quality ------------------------------------------------------------------

analyze: ## Run dart analyze across the workspace
	dart analyze

test: ## Run tests in all packages
	melos run test

format: ## Format all Dart files
	dart format .

format-check: ## Check formatting without modifying files
	dart format --set-exit-if-changed .

ci: analyze format-check test ## Run full CI pipeline (analyze + format check + test)

## Run Apps -----------------------------------------------------------------

run-boilerplate-dev: ## Run app_boilerplate with dev flavor
	@cd apps/app_boilerplate && flutter run --dart-define-from-file=env/dev.json

run-boilerplate-stg: ## Run app_boilerplate with stg flavor
	@cd apps/app_boilerplate && flutter run --dart-define-from-file=env/stg.json

run-boilerplate-prod: ## Run app_boilerplate with prod flavor
	@cd apps/app_boilerplate && flutter run --dart-define-from-file=env/prod.json

run-client-dev: ## Run client_example with dev flavor
	@cd apps/client_example && flutter run --dart-define-from-file=env/dev.json

run-client-stg: ## Run client_example with stg flavor
	@cd apps/client_example && flutter run --dart-define-from-file=env/stg.json

run-client-prod: ## Run client_example with prod flavor
	@cd apps/client_example && flutter run --dart-define-from-file=env/prod.json

## Build Apps ---------------------------------------------------------------

build-boilerplate-apk-dev: ## Build APK for app_boilerplate (dev)
	@cd apps/app_boilerplate && flutter build apk --dart-define-from-file=env/dev.json

build-boilerplate-apk-prod: ## Build APK for app_boilerplate (prod)
	@cd apps/app_boilerplate && flutter build apk --dart-define-from-file=env/prod.json

build-boilerplate-ios-dev: ## Build iOS for app_boilerplate (dev)
	@cd apps/app_boilerplate && flutter build ios --dart-define-from-file=env/dev.json --no-codesign

build-boilerplate-ios-prod: ## Build iOS for app_boilerplate (prod)
	@cd apps/app_boilerplate && flutter build ios --dart-define-from-file=env/prod.json --no-codesign

## Client App Generation ----------------------------------------------------

create-app: ## Create a new client app (usage: make create-app NAME=client_acme DISPLAY="Acme Corp" BUNDLE=com.acme.app)
	@if [ -z "$(NAME)" ] || [ -z "$(DISPLAY)" ] || [ -z "$(BUNDLE)" ]; then \
		echo "Usage: make create-app NAME=client_acme DISPLAY=\"Acme Corp\" BUNDLE=com.acme.app"; \
		exit 1; \
	fi
	./scripts/create_app.sh --name "$(NAME)" --display-name "$(DISPLAY)" --bundle-id "$(BUNDLE)"

## Cleanup ------------------------------------------------------------------

clean: ## Clean all packages (flutter clean + remove generated files)
	melos run clean
	@echo "=> Cleaned."

clean-all: clean ## Deep clean: remove all generated code, caches, and pods
	@echo "=> Removing generated files..."
	@find . -name "*.g.dart" -delete 2>/dev/null || true
	@find . -name "*.freezed.dart" -delete 2>/dev/null || true
	@find . -name "*.gr.dart" -delete 2>/dev/null || true
	@find . -name "*.module.dart" -delete 2>/dev/null || true
	@find . -name "*.config.dart" -delete 2>/dev/null || true
	@find . -type d -name ".dart_tool" -exec rm -rf {} + 2>/dev/null || true
	@find . -type d -name "build" -exec rm -rf {} + 2>/dev/null || true
	@echo "=> Deep clean complete. Run 'make setup' to rebuild."

## Help ---------------------------------------------------------------------

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
