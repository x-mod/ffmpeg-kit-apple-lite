#!/bin/bash
set -e

echo "========================================"
echo "🚀 Starting Package Step"
echo "========================================"

# 1️⃣ 基础检查
if [ ! -d "ffmpeg-kit" ]; then
  echo "❌ ffmpeg-kit directory not found"
  exit 1
fi

# 2️⃣ 打印版本
echo ""
echo "📦 ffmpeg-kit version:"
cd ffmpeg-kit
git describe --tags || true
cd ..

# 3️⃣ 打印 prebuilt 目录
echo ""
echo "========================================"
echo "📂 Listing prebuilt directory"
echo "========================================"

if [ ! -d "ffmpeg-kit/prebuilt" ]; then
  echo "❌ prebuilt directory not found"
  exit 1
fi

ls -R ffmpeg-kit/prebuilt

# 4️⃣ 查找 xcframework
echo ""
echo "========================================"
echo "🔎 Searching for XCFramework"
echo "========================================"

XC_PATH=$(find ffmpeg-kit/prebuilt -type d -name "*.xcframework" | head -n 1)

if [ -z "$XC_PATH" ]; then
  echo "❌ No XCFramework found!"
  exit 1
fi

echo "✅ Found XCFramework:"
echo "$XC_PATH"

# 5️⃣ 打印体积
echo ""
echo "📊 XCFramework Size:"
du -sh "$XC_PATH"

# 6️⃣ 复制到项目目录（推荐结构）
echo ""
echo "========================================"
echo "📁 Copying XCFramework to Project"
echo "========================================"

DEST_DIR="Frameworks/ios"

rm -rf "$DEST_DIR"
mkdir -p "$DEST_DIR"

cp -R "$XC_PATH" "$DEST_DIR/"

echo "✅ Copied to $DEST_DIR"

# 7️⃣ 可选：体积限制（25MB）
SIZE_MB=$(du -sm "$DEST_DIR" | cut -f1)

echo ""
echo "📊 Final Folder Size: ${SIZE_MB} MB"

# MAX_SIZE=25

# if [ "$SIZE_MB" -gt "$MAX_SIZE" ]; then
#   echo "❌ Size exceeds ${MAX_SIZE}MB limit!"
#   exit 1
# fi

echo ""
echo "========================================"
echo "✅ Package Step Finished Successfully"
echo "========================================"