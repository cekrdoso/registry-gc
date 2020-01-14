#!/bin/bash

REGISTRY=registry-fqdn

if [ $# -eq 1 ]; then
    IMAGES=$1
else
    IMAGES=$( curl -s -X GET https://${REGISTRY}/v2/_catalog | jq -r .repositories[] | sort )
fi

(
echo -n "{ \"data\": ["
COUNT=1
for IMAGE in ${IMAGES}; do
        TAGS=`curl -sSL -H "Accept: application/vnd.docker.distribution.manifest.v2+json" "https://${REGISTRY}/v2/${IMAGE}/tags/list"`
        [ $COUNT -gt 1 ] && echo -n ","
        echo -n " ${TAGS}"
        COUNT=$((COUNT + 1))
done
echo " ]}"
) | jq .
