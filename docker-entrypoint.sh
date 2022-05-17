#!/bin/bash
set -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo "Both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}

# Evaluate environment variables
for EV in $(env | grep -oE '^REGISTRY_[^=]+'); do
    file_env ${EV%%_FILE}
done

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
