#!/usr/bin/env bash
set -x

if [ -z "$FOREMAN_URL" ]; then
    echo "FOREMAN_URL missing"
    exit 1
fi

if [ -z "$PROXY_URL" ]; then
    echo "PROXY_URL missing"
    exit 1
fi

PROXY_CURL_BASE="curl -k"

proxy-curl() {
    PROXY_PATH=$1
    shift || :
    $PROXY_CURL_BASE -H 'Content-Type: application/json' ${PROXY_URL}${PROXY_PATH} "$@"
}

if [ "$1" = "check" ]; then
    proxy_features=$(proxy-curl /features)
    if ! echo $proxy_features | grep ssh > /dev/null; then
        echo "The proxy doesn't support the ssh feature: ${proxy_features}"
        exit 6
    fi
    exit 0
fi

echo "uploading facts"
`/upload_facts.rb`
