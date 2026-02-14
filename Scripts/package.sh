#!/bin/bash
set -e

OUTPUT_DIR="release"
IOS_DIR="build-output/FFmpegKitLite-iOS"
MACOS_DIR="build-output/FFmpegKitLite-macOS"

mkdir -p "$OUTPUT_DIR"

echo "📦 Packaging iOS xcframeworks..."

for XCFRAMEWORK in "$IOS_DIR"/*.xcframework; do
  NAME=$(basename "$XCFRAMEWORK" .xcframework)
  ZIP_PATH="$OUTPUT_DIR/${NAME}-ios.zip"

  echo "  → $NAME"
  ditto -c -k --sequesterRsrc --keepParent \
    "$XCFRAMEWORK" \
    "$ZIP_PATH"

  swift package compute-checksum "$ZIP_PATH" > "$OUTPUT_DIR/${NAME}-ios.checksum"
done


echo "📦 Packaging macOS xcframeworks..."

for XCFRAMEWORK in "$MACOS_DIR"/*.xcframework; do
  NAME=$(basename "$XCFRAMEWORK" .xcframework)
  ZIP_PATH="$OUTPUT_DIR/${NAME}-macos.zip"

  echo "  → $NAME"
  ditto -c -k --sequesterRsrc --keepParent \
    "$XCFRAMEWORK" \
    "$ZIP_PATH"

  swift package compute-checksum "$ZIP_PATH" > "$OUTPUT_DIR/${NAME}-macos.checksum"
done


echo "========================================"
echo "✅ Release Ready"
echo "========================================"

ls -lh "$OUTPUT_DIR"