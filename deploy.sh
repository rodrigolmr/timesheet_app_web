#!/bin/bash

echo "🚀 Starting deployment..."
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
echo "📱 Your app will now update immediately for users!"
echo ""
echo "💡 Tip: Users might need to refresh once to get the new version"