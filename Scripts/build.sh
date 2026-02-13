#!/bin/bash
set -e

echo "========================================"
echo "🚀 FFmpegKit Lite Universal Build"
echo "========================================"

# 创建临时目录（防止污染 workspace）
WORK_DIR=$(mktemp -d)
echo "📁 Using temp directory: $WORK_DIR"

# 克隆源码
git clone --depth 1 --branch v6.0 https://github.com/arthenica/ffmpeg-kit.git "$WORK_DIR"

cd "$WORK_DIR"

# 统一精简配置
export FFMPEG_CONFIGURE_OPTIONS="\
--disable-everything \
--enable-small \
--disable-programs \
--disable-doc \
--disable-debug \
--disable-network \
--disable-autodetect \
\
--enable-avcodec \
--enable-avformat \
--enable-avutil \
--enable-swresample \
--enable-swscale \
\
--enable-protocol=file \
\
--enable-demuxer=mov \
--enable-demuxer=matroska \
--enable-demuxer=avi \
--enable-demuxer=flv \
--enable-demuxer=webm \
--enable-demuxer=mpegts \
--enable-demuxer=mpegps \
--enable-demuxer=asf \
\
--enable-muxer=mp4 \
--enable-muxer=mov \
--enable-muxer=adts \
\
--enable-decoder=h264 \
--enable-decoder=hevc \
--enable-decoder=mpeg4 \
--enable-decoder=mpeg2video \
--enable-decoder=vp8 \
--enable-decoder=vp9 \
\
--enable-decoder=aac \
--enable-decoder=mp3 \
--enable-decoder=ac3 \
\
--enable-parser=h264 \
--enable-parser=hevc \
--enable-parser=mpeg4video \
\
--enable-encoder=h264_videotoolbox \
--enable-encoder=aac \
\
--enable-hwaccel=h264_videotoolbox \
"

echo "========================================"
echo "📱 Building iOS"
echo "========================================"

./ios.sh \
  --xcframework \
  --enable-ios-videotoolbox \
  --enable-ios-audiotoolbox \
  --enable-ios-zlib

echo "========================================"
echo "🖥 Building macOS"
echo "========================================"

./macos.sh \
  --xcframework \
  --enable-macos-videotoolbox \
  --enable-macos-audiotoolbox \
  --enable-macos-zlib

echo "========================================"
echo "📦 Merging XCFramework"
echo "========================================"

# 查找 iOS 和 macOS xcframework
IOS_XC=$(find prebuilt -type d -name "*ios*.xcframework" | head -n 1)
MAC_XC=$(find prebuilt -type d -name "*macos*.xcframework" | head -n 1)

if [ -z "$IOS_XC" ] || [ -z "$MAC_XC" ]; then
  echo "❌ Could not find both iOS and macOS XCFramework"
  exit 1
fi

echo "iOS XCFramework: $IOS_XC"
echo "macOS XCFramework: $MAC_XC"

# 回到项目目录
cd -

rm -rf build-output
mkdir -p build-output

# 创建最终统一 XCFramework
FINAL_NAME="FFmpegKitLite.xcframework"

xcodebuild -create-xcframework \
  -framework "$WORK_DIR/$IOS_XC/ios-arm64/ffmpegkit.framework" \
  -framework "$WORK_DIR/$IOS_XC/ios-arm64_x86_64-simulator/ffmpegkit.framework" \
  -framework "$WORK_DIR/$MAC_XC/macos-arm64_x86_64/ffmpegkit.framework" \
  -output "build-output/$FINAL_NAME"

echo "========================================"
echo "✅ Universal XCFramework Created"
echo "========================================"

du -sh "build-output/$FINAL_NAME"