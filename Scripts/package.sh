#!/bin/bash
set -e

mkdir -p artifacts

cp -R ffmpeg-kit/prebuilt/apple-ios-xcframework/*.xcframework artifacts/ffmpegkit-ios.xcframework
# cp -R ffmpeg-kit/prebuilt/apple-macos-xcframework/*.xcframework artifacts/ffmpegkit-macos.xcframework

cd artifacts

zip -r ffmpegkit-ios.zip ffmpegkit-ios.xcframework
# zip -r ffmpegkit-macos.zip ffmpegkit-macos.xcframework

IOS_CHECKSUM=$(shasum -a 256 ffmpegkit-ios.zip | awk '{print $1}')
# MAC_CHECKSUM=$(shasum -a 256 ffmpegkit-macos.zip | awk '{print $1}')

echo "IOS_CHECKSUM=$IOS_CHECKSUM" >> $GITHUB_ENV
# echo "MAC_CHECKSUM=$MAC_CHECKSUM" >> $GITHUB_ENV

cd ..