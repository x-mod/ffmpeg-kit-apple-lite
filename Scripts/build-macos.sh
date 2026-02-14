#!/bin/bash
set -e

echo "========================================"
echo "🖥 Building FFmpegKit Lite (macOS)"
echo "========================================"

WORK_DIR=$(mktemp -d)

git clone --depth 1 --branch v6.0 https://github.com/arthenica/ffmpeg-kit.git "$WORK_DIR"

cd "$WORK_DIR"

./macos.sh \
  --xcframework \
  --disable-x86-64 \
  --enable-macos-videotoolbox \
  --enable-macos-audiotoolbox \
  --enable-openssl \
  --enable-srt \
  --enable-macos-zlib

cd -

OUTPUT_DIR="build-output/FFmpegKitLite-macOS"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

cp -R "$WORK_DIR/prebuilt/bundle-apple-xcframework-macos/"* "$OUTPUT_DIR/"

echo "✅ macOS build complete"