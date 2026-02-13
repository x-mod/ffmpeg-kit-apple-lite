#!/bin/bash
set -e

echo "========================================"
echo "🚀 Starting Package Step"
echo "========================================"

if [ ! -d "ffmpeg-kit" ]; then
  echo "❌ ffmpeg-kit directory not found"
  exit 1
fi

echo ""
echo "📦 ffmpeg-kit version:"
cd ffmpeg-kit
git describe --tags || true
cd ..

echo ""
echo "========================================"
echo "📂 Listing prebuilt directory"
echo "========================================"

if [ ! -d "ffmpeg-kit/prebuilt" ]; then
  echo "❌ prebuilt directory not found"
  exit 1
fi

ls -R ffmpeg-kit/prebuilt

echo ""
echo "========================================"
echo "📊 XCFramework Size Info"
echo "========================================"

mkdir -p artifacts

# iOS
if [ -d "ffmpeg-kit/prebuilt/ios-xcframework" ]; then
  echo "📱 Found iOS XCFramework"
  du -sh ffmpeg-kit/prebuilt/ios-xcframework
  cp -R ffmpeg-kit/prebuilt/ios-xcframework/*.xcframework artifacts/
else
  echo "⚠️ iOS XCFramework not found"
fi

# macOS（可选）
if [ -d "ffmpeg-kit/prebuilt/macos-xcframework" ]; then
  echo "💻 Found macOS XCFramework"
  du -sh ffmpeg-kit/prebuilt/macos-xcframework
  cp -R ffmpeg-kit/prebuilt/macos-xcframework/*.xcframework artifacts/
else
  echo "⚠️ macOS XCFramework not found"
fi

echo ""
echo "========================================"
echo "📦 Creating ZIP"
echo "========================================"

cd artifacts

if ls *.xcframework 1> /dev/null 2>&1; then
  zip -r ffmpegkit-ios.zip *.xcframework
else
  echo "❌ No XCFramework found to zip"
  exit 1
fi

echo ""
echo "📊 ZIP Size:"
du -sh ffmpegkit-ios.zip

cd ..

echo ""
echo "========================================"
echo "✅ Package Step Finished"
echo "========================================"