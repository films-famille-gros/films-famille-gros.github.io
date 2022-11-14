#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))
docker build $script_dir/docker -t famille

export docker_tty="-it"
if ! tty > /dev/null; then
  export docker_tty=""
fi

docker run $docker_tty --rm=true \
    -u $UID:$(id -g) \
    -v $HOME:$HOME \
    -v $script_dir:$script_dir \
    -v $(pwd):$(pwd) \
    -v /tmp:/tmp \
    -w $(pwd) \
    famille:latest "$@"
