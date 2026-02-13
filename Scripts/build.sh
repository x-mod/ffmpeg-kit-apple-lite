#!/bin/bash
set -e

echo "========================================"
echo "🚀 FFmpegKit Lite Universal Build"
echo "========================================"

WORK_DIR=$(mktemp -d)
echo "📁 Temp dir: $WORK_DIR"

git clone --depth 1 --branch v6.0 https://github.com/arthenica/ffmpeg-kit.git "$WORK_DIR"

cd "$WORK_DIR"

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
--enable-muxer=mp4 \
\
--enable-decoder=h264 \
--enable-decoder=hevc \
--enable-decoder=aac \
--enable-decoder=mp3 \
\
--enable-encoder=h264_videotoolbox \
--enable-encoder=aac \
\
--enable-hwaccel=h264_videotoolbox \
"

########################################
# 📱 Build iOS
########################################

echo "📱 Building iOS..."

./ios.sh \
  --xcframework \
  --enable-ios-videotoolbox \
  --enable-ios-audiotoolbox \
  --enable-ios-zlib \
  --disable-armv7 \
  --disable-armv7s \
  --disable-i386 \
  --disable-arm64e

IOS_BUNDLE="$WORK_DIR/prebuilt/bundle-apple-xcframework-ios"

########################################
# 🖥 Build macOS
########################################

echo "🖥 Building macOS..."

./macos.sh \
  --xcframework \
  --enable-macos-videotoolbox \
  --enable-macos-audiotoolbox \
  --enable-macos-zlib \
  --disable-arm64 \
  --disable-x86-64

MAC_BUNDLE="$WORK_DIR/prebuilt/bundle-apple-xcframework-macos"

########################################
# 📦 Copy to final structure
########################################

cd -

FINAL_DIR="build-output/FFmpegKitLite"
rm -rf "$FINAL_DIR"

mkdir -p "$FINAL_DIR/ios"
mkdir -p "$FINAL_DIR/macos"

echo "📦 Copying iOS xcframeworks..."
cp -R "$IOS_BUNDLE/"* "$FINAL_DIR/ios/"

echo "📦 Copying macOS xcframeworks..."
cp -R "$MAC_BUNDLE/"* "$FINAL_DIR/macos/"

echo "========================================"
echo "✅ Build Complete"
echo "========================================"

echo "📂 Final structure:"
ls -R "$FINAL_DIR"