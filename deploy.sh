#!/bin/bash

echo "🚀 Starting deployment..."
echo ""

# Get current date and time
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Path to build config file
BUILD_CONFIG_FILE="lib/src/core/config/build_config.dart"

# Get current build number from build_config.dart
CURRENT_BUILD=$(grep "static const String buildNumber" "$BUILD_CONFIG_FILE" | sed "s/.*= '//" | sed "s/'.*//")

# Increment build number
NEW_BUILD=$((CURRENT_BUILD + 1))

# Get version from pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //' | sed 's/+.*//')

echo "📅 Updating build information..."
echo "   Version: $VERSION"
echo "   Build: $CURRENT_BUILD → $NEW_BUILD"
echo "   Date: $CURRENT_DATE"
echo ""

# Update pubspec.yaml with new build number
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/version: .*/version: $VERSION+$NEW_BUILD/" "pubspec.yaml"
    sed -i '' "s/static const String buildTimestamp = '.*';/static const String buildTimestamp = '$CURRENT_DATE';/" "$BUILD_CONFIG_FILE"
    sed -i '' "s/static const String version = '.*';/static const String version = '$VERSION';/" "$BUILD_CONFIG_FILE"
    sed -i '' "s/static const String buildNumber = '.*';/static const String buildNumber = '$NEW_BUILD';/" "$BUILD_CONFIG_FILE"
else
    # Linux
    sed -i "s/version: .*/version: $VERSION+$NEW_BUILD/" "pubspec.yaml"
    sed -i "s/static const String buildTimestamp = '.*';/static const String buildTimestamp = '$CURRENT_DATE';/" "$BUILD_CONFIG_FILE"
    sed -i "s/static const String version = '.*';/static const String version = '$VERSION';/" "$BUILD_CONFIG_FILE"
    sed -i "s/static const String buildNumber = '.*';/static const String buildNumber = '$NEW_BUILD';/" "$BUILD_CONFIG_FILE"
fi

# Update version.json in web folder
cat > web/version.json << EOF
{
  "version": "$VERSION",
  "buildNumber": "$NEW_BUILD",
  "buildDate": "$CURRENT_DATE"
}
EOF

echo "✅ Build information updated"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/web

# Build with PWA support
echo "🔨 Building Flutter web app..."
flutter build web --release

# Deploy to Firebase
echo "☁️  Deploying to Firebase..."
firebase deploy --only hosting

echo ""
echo "✅ Deploy completed successfully!"
echo "📱 Version $VERSION (Build $NEW_BUILD) is now live!"
echo ""
echo "💡 Users can check for updates in Settings > About"