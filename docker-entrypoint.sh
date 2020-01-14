#!/bin/sh
set -e

case "$1" in
    *.yaml|*.yml)
      # Garbage collect routine
      # Will exit when garbage collect delete something
      nohup sh -c "[ ${ENABLE_GARBAGE_COLLECT:-false} == \"true\" ] && \
        while true; do \
          sleep ${GARBAGE_COLLECT_INTERVAL:-3600}; \
          registry garbage-collect -m /etc/docker/registry/config.yml 2>&1 | \
          tee -a /proc/1/fd/1 | \
          grep -q \"Deleting blob\" && sleep 5 && kill -HUP 1; \
        done" >/dev/null &
      set -- registry serve "$@"
    ;;
    serve|garbage-collect|help|-*) set -- registry "$@" ;;
esac

exec "$@"
