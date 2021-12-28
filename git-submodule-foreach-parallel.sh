#!/bin/bash

if [ -z "$1" ]; then
    echo "Missing Command" >&2
    exit 1
fi

COMMAND="$@"

IFS=$'\n'
for DIR in $(git submodule foreach --recursive -q sh -c pwd); do
    printf "\n\nStarted running command \"${COMMAND}\" in directory \"${DIR}\"\n\n" \
    && \
    cd "$DIR" \
    && \
    eval "$COMMAND" \
    && \
    printf "\nFinished running command \"${COMMAND}\" in directory \"${DIR}\"\n\n" \
    &
done
wait