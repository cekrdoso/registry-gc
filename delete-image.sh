#!/bin/bash

PRIVATE_REGISTRY=${DOCKER_REGISTRY-}

[ -z "${PRIVATE_REGISTRY}" ] && \
    echo "ERROR: You must export DOCKER_REGISTRY with registry's fqdn." && \
    exit 1

TAG=${1#*:}
REPOSITORY=${1%:*}

if [ -z "${TAG}" ] ||
    [ -z "${REPOSITORY}" ]; then
    echo "Usage: $0 <repository>:<tag>"
    exit 1
fi

MANIFEST=$(curl -sSL -I -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    "https://${PRIVATE_REGISTRY}/v2/${REPOSITORY}/manifests/${TAG}" | \
    awk '/^docker-content-digest:/ { print $2 }' | tr -d $'\r')

echo TAG ${TAG}
echo REPOSITORY ${REPOSITORY}
echo MANIFEST ${MANIFEST}

[ -z "${MANIFEST}" ] && echo "ERROR: Manifest not found" && exit 1

echo -n -e "\nType 'yes' to continue [no]: "
read -r ANSWER

[[ ! ${ANSWER:-"no"} =~ ^[Yy][Ee][Ss]$ ]] && echo "Abort!" && exit 0

curl -X DELETE https://${PRIVATE_REGISTRY}/v2/${REPOSITORY}/manifests/${MANIFEST}
