#!/usr/bin/env bash
set -eu
OS='MacOS'

source ./utils/output.sh

# Parameters:
#   $1: seconds
function count_down() {
    seconds=$1
    while [[ $seconds -gt 0 ]]; do
        echo -n "$seconds " | color_print 0 -n
        sleep 1
        seconds=$(($seconds-1))
    done
    color_print 0 '0'
}

count_down 3


