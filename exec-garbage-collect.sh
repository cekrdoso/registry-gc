#!/bin/sh

ENABLE_GARBAGE_COLLECT=${ENABLE_GARBAGE_COLLECT:-false}
GARBAGE_COLLECT_INTERVAL=${GARBAGE_COLLECT_INTERVAL:-3600}
GARBAGE_COLLECT_SCHEDULE=${GARBAGE_COLLECT_SCHEDULE-}

exec_gc() {
    echo "$(date) Executando garbage collect ..."
    registry garbage-collect -m /etc/docker/registry/config.yml 2>&1 | \
        grep -q "Deleting blob" && sleep 5 && kill -HUP 1
}

[ "${ENABLE_GARBAGE_COLLECT}" != "true" ] && exit 0

while true; do
    if [ "${GARBAGE_COLLECT_SCHEDULE}x" = "x" ]; then

        sleep ${GARBAGE_COLLECT_INTERVAL}
 
    else
    
        sleep 60
        EXEC_GC=0
        for SCHED in ${GARBAGE_COLLECT_SCHEDULE}; do

            DATE_FORMAT=${SCHED%%@*}
            SCHED_TIME=${SCHED##*@}
            FORMATED_NOW=$(date +"${DATE_FORMAT}")
            [ "${FORMATED_NOW}x" = "${SCHED_TIME}x" ] && EXEC_GC=1 && break

        done

        [ ${EXEC_GC} -eq 0 ] && continue
    
    fi
    exec_gc
done
