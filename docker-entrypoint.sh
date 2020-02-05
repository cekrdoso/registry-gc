#!/bin/sh
set -e

case "$1" in
    *.yaml|*.yml)
      # Garbage collect routine
      # Will exit when garbage collect delete something
      /exec-garbage-collect.sh 2>&1 &
      set -- registry serve "$@"
    ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
esac

exec "$@"
