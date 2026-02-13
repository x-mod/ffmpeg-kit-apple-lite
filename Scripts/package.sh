#!/bin/bash
set -e

mkdir -p release

echo "📦 Packaging iOS..."
ditto -c -k --sequesterRsrc --keepParent \
  build-output/FFmpegKitLite-iOS \
  release/FFmpegKitLite-iOS.zip

echo "📦 Packaging macOS..."
ditto -c -k --sequesterRsrc --keepParent \
  build-output/FFmpegKitLite-macOS \
  release/FFmpegKitLite-macOS.zip

echo "🔐 Generating checksums..."

swift package compute-checksum release/FFmpegKitLite-iOS.zip > release/ios.checksum
swift package compute-checksum release/FFmpegKitLite-macOS.zip > release/macos.checksum

echo "========================================"
echo "✅ Release Ready"
echo "========================================"

ls -lh release