#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )

lockFile="$SCRIPT_DIR/.lock"

lock() {
    dotlockfile -r 0 -p $lockFile
}

release() {
    dotlockfile -r 0 -u $lockFile
}

trapped() {
    excode=$?
    if [ $excode -ne 0 ]; then
        echo 'error'

        # ignore EXIT signal after a SIGINT or SIGTERM
        trap "" EXIT
    fi
}

trap "trapped" SIGINT SIGTERM EXIT

set +e
if ! lock; then
    echo 'There is already a deployment in progress ...'
    exit 1
fi
set -e

sleep 2

release
