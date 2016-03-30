#!/usr/bin/env bash

set -e

trapped() {
    excode=$?
    if [ $excode -ne 0 ]; then
        echo 'error'

        # ignore EXIT signal after a SIGINT or SIGTERM
        trap "" EXIT
    fi
}

trap "trapped" SIGINT SIGTERM EXIT

duration=(1 2 3)

stuff() {
    echo "started sleeping for $1 seconds"
    sleep $1
    if test $1 == "1"; then
        return 1
    fi;
    echo "finished sleeping after $1 seconds"
}

for i in "${!duration[@]}"; do
    stuff ${duration[$i]} &
    storedPids[$i]=$!
done
for i in "${!duration[@]}"; do
    wait ${storedPids[$i]}
done

echo 'NEXT'
