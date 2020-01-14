#!/bin/bash

REGISTRY=registry-fqdn

TAG=${1#*:}
REPOSITORY=${1%:*}

MANIFEST=$(curl -sSL -I -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
        "https://${REGISTRY}/v2/${REPOSITORY}/manifests/${TAG}" | \
        awk '/^docker-content-digest:/ { print $2 }' | tr -d $'\r')

echo TAG ${TAG}
echo REPOSITORY ${REPOSITORY}
echo MANIFEST ${MANIFEST}

[ -z "${MANIFEST}" ] && echo "ERROR: Manifest not found" && exit 1

echo -n -e "\nType 'yes' to continue [no]: "
read -r ANSWER

[[ ! ${ANSWER:-"no"} =~ ^[Yy][Ee][Ss]$ ]] && echo "Abort!" && exit 0

curl -X DELETE https://${REGISTRY}/v2/${REPOSITORY}/manifests/${MANIFEST}
