#!/bin/bash
set -e

FINAL_DIR="build-output/FFmpegKitLite"
ZIP_NAME="FFmpegKitLite.zip"

rm -f "$ZIP_NAME"

ditto -c -k --sequesterRsrc --keepParent "$FINAL_DIR" "$ZIP_NAME"

echo "🔐 Generating checksum..."
CHECKSUM=$(swift package compute-checksum "$ZIP_NAME")

echo "$CHECKSUM" > checksum.txt

echo "========================================"
echo "✅ Done"
echo "Checksum: $CHECKSUM"
echo "========================================"

du -sh "$ZIP_NAME"