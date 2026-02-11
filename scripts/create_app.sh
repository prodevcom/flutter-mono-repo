#!/bin/bash
set -euo pipefail

# =============================================================================
# MonoApp - Client App Generator
# Creates a new client app from the app_boilerplate template
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
BOILERPLATE_DIR="$ROOT_DIR/apps/app_boilerplate"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Defaults
NAME=""
DISPLAY_NAME=""
BUNDLE_ID=""
ORG=""

usage() {
  echo "Usage: $0 --name <app_name> --display-name <display_name> --bundle-id <bundle_id>"
  echo ""
  echo "Options:"
  echo "  --name          App directory name (e.g., client_acme)"
  echo "  --display-name  Display name for the app (e.g., \"Acme Corp\")"
  echo "  --bundle-id     Bundle identifier (e.g., com.acme.app)"
  echo ""
  echo "Example:"
  echo "  $0 --name client_acme --display-name \"Acme Corp\" --bundle-id com.acme.app"
  exit 1
}

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --name) NAME="$2"; shift 2 ;;
    --display-name) DISPLAY_NAME="$2"; shift 2 ;;
    --bundle-id) BUNDLE_ID="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) log_error "Unknown option: $1"; usage ;;
  esac
done

# Validate required args
if [[ -z "$NAME" || -z "$DISPLAY_NAME" || -z "$BUNDLE_ID" ]]; then
  log_error "Missing required arguments"
  usage
fi

# Extract org from bundle id (everything except last segment)
ORG=$(echo "$BUNDLE_ID" | rev | cut -d'.' -f2- | rev)

APP_DIR="$ROOT_DIR/apps/$NAME"

# Check if app already exists
if [[ -d "$APP_DIR" ]]; then
  log_error "App directory already exists: $APP_DIR"
  exit 1
fi

# Check boilerplate exists
if [[ ! -d "$BOILERPLATE_DIR" ]]; then
  log_error "Boilerplate not found at: $BOILERPLATE_DIR"
  exit 1
fi

log_info "Creating new client app: $NAME"
log_info "Display Name: $DISPLAY_NAME"
log_info "Bundle ID: $BUNDLE_ID"
log_info "Organization: $ORG"
echo ""

# Step 1: Copy boilerplate
log_info "1/8 Copying boilerplate..."
cp -r "$BOILERPLATE_DIR" "$APP_DIR"

# Remove generated files and build artifacts
rm -rf "$APP_DIR/.dart_tool"
rm -rf "$APP_DIR/build"
rm -rf "$APP_DIR/lib/l10n/generated"
mkdir -p "$APP_DIR/lib/l10n/generated"
touch "$APP_DIR/lib/l10n/generated/.gitkeep"
find "$APP_DIR" -name "*.g.dart" -delete 2>/dev/null || true
find "$APP_DIR" -name "*.freezed.dart" -delete 2>/dev/null || true
find "$APP_DIR" -name "*.config.dart" -delete 2>/dev/null || true
find "$APP_DIR" -name "*.gr.dart" -delete 2>/dev/null || true
rm -f "$APP_DIR/pubspec_overrides.yaml"

# Step 2: Update pubspec.yaml
log_info "2/8 Updating pubspec.yaml..."
sed -i '' "s/^name: app_boilerplate/name: $NAME/" "$APP_DIR/pubspec.yaml"
sed -i '' "s/description: .*/description: $DISPLAY_NAME app/" "$APP_DIR/pubspec.yaml"

# Step 3: Update bundle IDs - Android
log_info "3/8 Updating Android configuration..."
if [[ -f "$APP_DIR/android/app/build.gradle.kts" ]]; then
  sed -i '' "s/com\.monoapp\.app_boilerplate/$BUNDLE_ID/g" "$APP_DIR/android/app/build.gradle.kts"
  sed -i '' "s/com\.monoapp\.appBoilerplate/$BUNDLE_ID/g" "$APP_DIR/android/app/build.gradle.kts"
elif [[ -f "$APP_DIR/android/app/build.gradle" ]]; then
  sed -i '' "s/com\.monoapp\.app_boilerplate/$BUNDLE_ID/g" "$APP_DIR/android/app/build.gradle"
  sed -i '' "s/com\.monoapp\.appBoilerplate/$BUNDLE_ID/g" "$APP_DIR/android/app/build.gradle"
fi

# Update Android namespace/package in Kotlin/Java files
ANDROID_PACKAGE_PATH=$(echo "$BUNDLE_ID" | tr '.' '/')
OLD_PACKAGE_PATH="com/monoapp/app_boilerplate"
if [[ -d "$APP_DIR/android/app/src/main/kotlin/$OLD_PACKAGE_PATH" ]]; then
  mkdir -p "$APP_DIR/android/app/src/main/kotlin/$ANDROID_PACKAGE_PATH"
  mv "$APP_DIR/android/app/src/main/kotlin/$OLD_PACKAGE_PATH/MainActivity.kt" \
     "$APP_DIR/android/app/src/main/kotlin/$ANDROID_PACKAGE_PATH/" 2>/dev/null || true
  sed -i '' "s/package com\.monoapp\.app_boilerplate/package $BUNDLE_ID/" \
     "$APP_DIR/android/app/src/main/kotlin/$ANDROID_PACKAGE_PATH/MainActivity.kt" 2>/dev/null || true
fi

# Update AndroidManifest
find "$APP_DIR/android" -name "AndroidManifest.xml" -exec \
  sed -i '' "s/com\.monoapp\.app_boilerplate/$BUNDLE_ID/g" {} \; 2>/dev/null || true

# Update app label in AndroidManifest
find "$APP_DIR/android" -name "AndroidManifest.xml" -exec \
  sed -i '' "s/android:label=\"[^\"]*\"/android:label=\"$DISPLAY_NAME\"/" {} \; 2>/dev/null || true

# Step 4: Update bundle IDs - iOS
log_info "4/8 Updating iOS configuration..."
if [[ -f "$APP_DIR/ios/Runner.xcodeproj/project.pbxproj" ]]; then
  sed -i '' "s/com\.monoapp\.appBoilerplate/$BUNDLE_ID/g" "$APP_DIR/ios/Runner.xcodeproj/project.pbxproj"
  sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = [^;]*/PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE_ID/" \
     "$APP_DIR/ios/Runner.xcodeproj/project.pbxproj"
fi

# Update Info.plist display name
if [[ -f "$APP_DIR/ios/Runner/Info.plist" ]]; then
  sed -i '' "s/<string>app_boilerplate<\/string>/<string>$DISPLAY_NAME<\/string>/" "$APP_DIR/ios/Runner/Info.plist"
fi

# Step 5: Generate theme files for customization
log_info "5/8 Creating theme customization files..."
cat > "$APP_DIR/lib/theme/app_theme.dart" << THEME_EOF
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// $DISPLAY_NAME theme overrides.
/// Customize colors, typography, etc. for this client app.
class ${NAME}Theme {
  ${NAME}Theme._();

  // Override the seed color to customize the entire color scheme
  static ThemeData get light => AppTheme.light;

  static ThemeData get dark => AppTheme.dark;
}
THEME_EOF

# Step 6: Update env files
log_info "6/8 Updating environment configs..."
cat > "$APP_DIR/env/dev.json" << ENV_EOF
{
  "FLAVOR": "dev",
  "APP_NAME": "$DISPLAY_NAME Dev",
  "BASE_URL": "https://dev-api.example.com/v1"
}
ENV_EOF

cat > "$APP_DIR/env/stg.json" << ENV_EOF
{
  "FLAVOR": "stg",
  "APP_NAME": "$DISPLAY_NAME Stg",
  "BASE_URL": "https://stg-api.example.com/v1"
}
ENV_EOF

cat > "$APP_DIR/env/prod.json" << ENV_EOF
{
  "FLAVOR": "prod",
  "APP_NAME": "$DISPLAY_NAME",
  "BASE_URL": "https://api.example.com/v1"
}
ENV_EOF

# Step 7: Add to root pubspec.yaml workspace
log_info "7/8 Adding to workspace..."
if ! grep -q "apps/$NAME" "$ROOT_DIR/pubspec.yaml"; then
  sed -i '' "/  - apps\/client_example/a\\
\\  - apps/$NAME" "$ROOT_DIR/pubspec.yaml"
fi

# Step 8: Update app_boilerplate references in Dart files
log_info "8/8 Updating Dart imports..."
find "$APP_DIR/lib" -name "*.dart" -exec \
  sed -i '' "s/package:app_boilerplate/package:$NAME/g" {} \;

echo ""
log_info "Client app '$NAME' created successfully at: $APP_DIR"
log_info ""
log_info "Next steps:"
log_info "  1. Run: melos bootstrap"
log_info "  2. Run: melos run gen"
log_info "  3. Run: melos run l10n"
log_info "  4. Customize theme in: apps/$NAME/lib/theme/app_theme.dart"
log_info "  5. Customize translations in: apps/$NAME/lib/l10n/"
log_info "  6. Run: flutter run --dart-define-from-file=env/dev.json"
