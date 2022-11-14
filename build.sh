#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))
pushd $script_dir
make html
