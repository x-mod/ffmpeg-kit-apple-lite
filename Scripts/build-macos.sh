#!/bin/bash
set -e

echo "========================================"
echo "🖥 Building FFmpegKit Lite (macOS)"
echo "========================================"

WORK_DIR=$(mktemp -d)

git clone --depth 1 --branch v6.0 https://github.com/arthenica/ffmpeg-kit.git "$WORK_DIR"

cd "$WORK_DIR"

# ⚠️ 清空 prebuilt 防止重复库标识符
rm -rf prebuilt

# 构建 macOS XCFramework
./macos.sh \
  --xcframework \
  --disable-x86-64 \
  --enable-macos-videotoolbox \
  --enable-macos-audiotoolbox \
  --enable-macos-zlib

cd -

OUTPUT_DIR="build-output/FFmpegKitLite-macOS"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# FFmpegKit 生成的 XCFramework 路径
XCFRAMEWORK_DIR="$WORK_DIR/prebuilt/bundle-apple-xcframework-macos"

# 自动遍历所有 xcframework 并准备 xcodebuild 参数
XCODEBUILD_ARGS=()
for FRAMEWORK in "$XCFRAMEWORK_DIR"/*.xcframework; do
  FRAMEWORK_NAME=$(basename "$FRAMEWORK" .xcframework)
  for PLATFORM_DIR in "$FRAMEWORK"/*; do
    if [[ -d "$PLATFORM_DIR" && -f "$PLATFORM_DIR/$FRAMEWORK_NAME.framework/Info.plist" ]]; then
      XCODEBUILD_ARGS+=("-framework" "$PLATFORM_DIR/$FRAMEWORK_NAME.framework")
    fi
  done
done

# 创建统一 XCFramework
UNIFIED_XCFRAMEWORK="$OUTPUT_DIR/FFmpegKitLite.xcframework"
xcodebuild -create-xcframework "${XCODEBUILD_ARGS[@]}" -output "$UNIFIED_XCFRAMEWORK"

echo "✅ macOS build complete: $UNIFIED_XCFRAMEWORK"