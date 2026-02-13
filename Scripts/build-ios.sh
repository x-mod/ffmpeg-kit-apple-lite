#!/bin/bash
set -e

echo "========================================"
echo "📱 Building FFmpegKit Lite (iOS)"
echo "========================================"

WORK_DIR=$(mktemp -d)

git clone --depth 1 --branch v6.0 https://github.com/arthenica/ffmpeg-kit.git "$WORK_DIR"

cd "$WORK_DIR"

# ⚠️ 清空 prebuilt，避免重复库标识符
rm -rf prebuilt

# 构建 iOS XCFramework
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

# FFmpegKit 生成的 XCFramework 路径
XCFRAMEWORK_DIR="$WORK_DIR/prebuilt/bundle-apple-xcframework-ios"

# 自动遍历所有 xcframework
XCODEBUILD_ARGS=()
for FRAMEWORK in "$XCFRAMEWORK_DIR"/*.xcframework; do
  FRAMEWORK_NAME=$(basename "$FRAMEWORK" .xcframework)
  for PLATFORM_DIR in "$FRAMEWORK"/*; do
    if [[ -d "$PLATFORM_DIR" && -f "$PLATFORM_DIR/$FRAMEWORK_NAME.framework/Info.plist" ]]; then
      XCODEBUILD_ARGS+=("-framework" "$PLATFORM_DIR/$FRAMEWORK_NAME.framework")
    fi
  done
done

# 输出统一 XCFramework
UNIFIED_XCFRAMEWORK="$OUTPUT_DIR/FFmpegKitLite.xcframework"
xcodebuild -create-xcframework "${XCODEBUILD_ARGS[@]}" -output "$UNIFIED_XCFRAMEWORK"

echo "✅ iOS build complete: $UNIFIED_XCFRAMEWORK"