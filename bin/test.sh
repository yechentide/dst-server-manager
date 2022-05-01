#!/usr/bin/env bash
set -euf

declare -r BIN_DIR=$(cd $(dirname $0); pwd)
export PATH="$BIN_DIR/output:$BIN_DIR/interaction:$BIN_DIR/environment:$PATH"
declare -r answer_path="$bin_dir/../.cache/answer"
declare -r array_path="$bin_dir/../.cache/array"

color_print info hello
