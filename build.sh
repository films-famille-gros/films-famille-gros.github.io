#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))
pushd $script_dir
# get dates in french
export LC_TIME=fr_FR.UTF-8
make html
