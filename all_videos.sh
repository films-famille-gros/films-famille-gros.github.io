#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname $(readlink -f $0))"

mkdir -p videos
for video in _static/*mp4; do
    base=$(basename $video)
    if [ ! -f videos/$base ]; then
        echo "transform video $video"
        ./transform_video.sh $video videos/$base
        git add videos/$base
        git commit -a -m "treat video $base"
    else
        echo "video $base already done"
    fi
done
