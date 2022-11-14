#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" >&2
    exit 1
}

stabilize()
{
    local in=$1; shift
    local out=$1; shift
    # https://www.paulirish.com/2021/video-stabilization-with-ffmpeg-and-vidstab/
    # https://tk-sls.de/wp/4018
    ffmpeg -i $in -vf vidstabdetect -f null -
    ffmpeg -i $in -crf 0 -vf vidstabtransform $out
}

compare()
{
    local before=$1; shift
    local after=$1; shift
    local out=$1; shift
    ffmpeg -i $before -i $after -filter_complex hstack -vsync 2 $out
}

deflicker()
{
    local in=$1; shift
    local out=$1; shift
    ffmpeg -i $in -crf 0 -vf deflicker $out
}

interpolate()
{
    local in=$1; shift
    local out=$1; shift
    local target_framerate=$1; shift
    # https://blog.programster.org/ffmpeg-create-smooth-videos-with-frame-interpolation
    ffmpeg -i $in -crf 0 \
      -vf "minterpolate=fps=$target_framerate:mi_mode=mci:mc_mode=aobmc:me_mode=bidir:vsbmc=1"\
      $out
}

denoise()
{
    local in=$1; shift
    local out=$1; shift
    # https://dirk-farin.net/projects/nlmeans/index.html
    # https://forum.videohelp.com/threads/398880-Optimising-Performance-of-NLMeans-in-FFmpeg
    ffmpeg -i $in -crf 0 -vf nlmeans=1.0:7:5:3:3 $out
}

get_duration_seconds()
{
    local in=$1; shift
    mediainfo --Output="Video;%Duration%\n" $in |
        awk '{ sum += $1 } END { secs=sum/1000; h=int(secs/3600);m=int((secs-h*3600)/60);s=int(secs-h*3600-m*60); printf("%00d\n",h*3600 + m*60 + s) }'
}

encode()
{
    local in=$1; shift
    local out=$1; shift
    local target_size_mb=$1; shift
    local duration=$(get_duration_seconds $in)
    local target_size_kb=$((target_size_mb * 8192))
    local bitrate=$((target_size_kb / (duration + 1)))

    # 2-pass encoding
    # h265 is not supported in web browsers and av1 is pretty recent, thus h264
    # https://trac.ffmpeg.org/wiki/Encode/H.264
    ffmpeg -i $in -c:v libx264 -preset veryslow -b:v ${bitrate}k -pass 1 -an -f null /dev/null
    ffmpeg -i $in -c:v libx264 -preset veryslow -b:v ${bitrate}k -pass 2 $out
}

fix_framerate()
{
    local in=$1; shift
    local out=$1; shift
    local target_framerate=$1; shift
    local stream=stream.h264
    # https://stackoverflow.com/questions/45462731/using-ffmpeg-to-change-framerate
    ffmpeg -i $in -c copy -f h264 $stream
    ffmpeg -r $target_framerate -i $stream -c copy $out
    rm $stream
}

run()
{
    pushd $tmp
    local func=$1; shift
    echo "** RUN: $func"
    $func in.mp4 out.mp4 "$@"
    echo "--------------------------------------------"
    date
    echo "--------------------------------------------"
    mv out.mp4 in.mp4
    popd
}

[ $# -eq 2 ] || die "usage: in_file out_file"
in=$1; shift
out=$1; shift

tmp=$(pwd)/tmp_transform
mkdir -p $tmp
trap "rm -rf $tmp" EXIT

cp $in $tmp/in.mp4
# Videos are scanned at 20 fps, but were shot at 16 (for 8mm) or 18 (super 8).
run fix_framerate 16
run denoise
run deflicker
run stabilize
run interpolate 30
run encode 99 # 99 MB target
cp $tmp/in.mp4 $out
#rm -f compare.mp4
#compare $in $out compare.mp4
#du -h $in $out
