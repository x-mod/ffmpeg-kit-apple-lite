#!/bin/bash
set -e

echo "========================================"
echo "📱 Building FFmpegKit Lite (iOS)"
echo "========================================"

WORK_DIR=$(mktemp -d)

git clone --depth 1 --branch v6.0 https://github.com/arthenica/ffmpeg-kit.git "$WORK_DIR"

cd "$WORK_DIR"

./ios.sh \
  --xcframework \
  --disable-armv7 \
  --disable-armv7s \
  --disable-arm64e \
  --disable-i386 \
  --disable-x86-64 \
  --disable-x86-64-mac-catalyst \
  --disable-arm64-mac-catalyst \
  --enable-ios-videotoolbox \
  --enable-ios-audiotoolbox \
  --enable-ios-zlib \
  --no-bitcode

cd -

OUTPUT_DIR="build-output/FFmpegKitLite-iOS"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# cp -R prebuilt/ffmpegkit.xcframework output/
cp -R "$WORK_DIR/prebuilt/bundle-apple-xcframework-ios/ffmpegkit.xcframework" "$OUTPUT_DIR/"

echo "✅ iOS build complete"