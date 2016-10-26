#!/usr/bin/env bash

set -eo pipefail

SOURCE="${BASH_SOURCE[0]}"
SERVER_RSA=ssh/id_rsa_server
CLIENT_RSA=ssh/id_rsa_foreman_proxy
KNOWN_HOSTS=ssh/known_hosts

MASTER_IP=$(ip -4 addr show docker0 | grep -o 'inet.*' | grep -oP '\d+\.\d+\.\d+\.\d+')
if ! [ -e settings.sh ]; then
    cp settings.sh.example settings.sh
fi
. settings.sh

usage() {
cat <<USAGE
usage: $0 ACTION

Build and run containers to test out the Foreman Remote Execution plugin

  # generate keys and build docker image first:
  $0 build

  # run container using the image
  $0 run -c $CONTAINER_NAME

  # ssh to the machine
  $0 ssh -c $CONTAINER_NAME
USAGE
}

ACTION=$1
shift || :

while getopts "c:f" opt; do
   case $opt in
     i)
       IMAGE_NAME="$OPTARG"
       ;;
     c)
       CONTAINER_NAME="$OPTARG"
       ;;
     f)
       FORCE=1
       ;;
   esac
done

IMAGE_NAME=${IMAGE_NAME:-foreman-remote-execution-target}
CONTAINER_NAME=${CONTAINER_NAME:-client.foreman.test}
MAC="52:54:00$(echo "$(hostname)$CONTAINER_NAME" | openssl dgst -md5 -binary | hexdump -e '/1 ":%02x"' -n 3)"

_build() {
    for key in $SERVER_RSA $CLIENT_RSA; do
        if ! [ -e $key ]; then
            echo "Generating $key…"
            ssh-keygen -t rsa -b 4096 -f $key -N ''
        fi
    done

    docker build -t $IMAGE_NAME .
}

_run() {
    if docker inspect $CONTAINER_NAME ; then
        echo "mac is $MAC"
        echo "Container $CONTAINER_NAME exist. Use 'run -f' to force the container deletion "
        if [ "$FORCE" = "1" ]; then
            echo "forced deletion"
            docker rm -f $CONTAINER_NAME
        else
            exit 2
        fi
    fi

    HOST_NAME=$(echo $CONTAINER_NAME | sed 's/_/-/g')

    if ! PROXY_URL=$PROXY_URL FOREMAN_URL=$FOREMAN_URL ./scripts/register-host.sh check; then
        exit 4
    fi
    CID=$(docker run -d --mac-address "$MAC" -h "$HOST_NAME" -e "HOST_NAME=$HOST_NAME" -e "PROXY_URL=$PROXY_URL" -e "FOREMAN_URL=$FOREMAN_URL" --name $CONTAINER_NAME $IMAGE_NAME)
    IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CID)
    if [ -z "$IP" ]; then
        echo "Could not get the container IP address"
        exit 3
    fi
    echo "IP address of '$CONTAINER_NAME' is $IP"
    sed -i /^$IP/d $KNOWN_HOSTS
    echo $IP $(cat ${SERVER_RSA}.pub) >> $KNOWN_HOSTS
}

_ssh() {
    IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER_NAME) || :
    if [ -z "$IP" ]; then
        echo "Could not find the container IP address, have you run '$0 run' before"
        exit 4
    fi
    SSH_USER=root
    echo "ssh as a ${SSH_USER} to ${CONTAINER_NAME} ($IP)"

    ssh $SSH_USER@${IP} -F ssh/config -v
}

case "$ACTION" in
    build)
        _build
        ;;
    run)
        _run
        ;;
    ssh)
        _ssh
        ;;
    "")
        echo "ACTION not specified"
        usage
        exit 1
        ;;
    *)
        echo "Unknon action "$ACTION""
        usage
        exit 1
        ;;
esac

