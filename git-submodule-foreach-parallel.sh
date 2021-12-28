#!/bin/bash

if [ -z "$1" ]; then
    echo "Missing Command" >&2
    exit 1
fi

COMMAND="$@"

IFS=$'\n'
for DIR in $(git submodule foreach --recursive -q sh -c pwd); do
    printf "\nStarted running command \"${COMMAND}\" in directory \"${DIR}\"\n" \
    && \
    cd "$DIR" \
    && \
    eval "$COMMAND" \
    && \
    printf "Finished running command \"${COMMAND}\" in directory \"${DIR}\"\n"
#    todo uncomment when google cloud repositories starts supporting parallel requests
#    &
done
wait