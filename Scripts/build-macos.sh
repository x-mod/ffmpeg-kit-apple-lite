#!/bin/bash
set -e

FFMPEG_VERSION=6.0

git clone --depth 1 --branch v${FFMPEG_VERSION} https://github.com/arthenica/ffmpeg-kit.git
cd ffmpeg-kit

./macos.sh all \
  --disable-armv7 \
  --disable-armv7s \
  \
  --disable-gpl \
  --disable-nonfree \
  --disable-debug \
  --disable-programs \
  --disable-doc \
  --disable-avdevice \
  --disable-postproc \
  --disable-network \
  --disable-autodetect \
  --disable-everything \
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
  --enable-decoder=wmv3 \
  --enable-decoder=msmpeg4v3 \
  \
  --enable-decoder=aac \
  --enable-decoder=mp3 \
  --enable-decoder=ac3 \
  --enable-decoder=pcm_s16le \
  --enable-decoder=vorbis \
  \
  --enable-parser=h264 \
  --enable-parser=hevc \
  --enable-parser=mpeg4video \
  --enable-parser=mpegaudio \
  --enable-parser=aac \
  \
  --enable-videotoolbox \
  --enable-hwaccel=h264_videotoolbox \
  \
  --enable-encoder=h264_videotoolbox \
  --enable-encoder=aac \
  \
  --enable-small \
  --disable-runtime-cpudetect \
  \
  --enable-xcframework

cd ..