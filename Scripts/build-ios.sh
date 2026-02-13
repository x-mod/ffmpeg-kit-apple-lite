#!/bin/bash
set -e

git clone --depth 1 --branch v6.0 https://github.com/arthenica/ffmpeg-kit.git
cd ffmpeg-kit

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
--enable-encoder=h264_videotoolbox \
--enable-encoder=aac \
\
--enable-hwaccel=h264_videotoolbox \
"

./ios.sh \
  --xcframework \
  --enable-ios-videotoolbox \
  --enable-ios-audiotoolbox \
  --enable-ios-zlib \
  --disable-armv7 \
  --disable-armv7s \
  --disable-i386 \
  --disable-arm64e

cd ..