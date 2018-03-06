#!/bin/sh

if [ -f /home/user/extension/cleanup.sh ]
then
    cleanup() {
        sh /home/user/extension/cleanup.sh
    } &&
    trap cleanup EXIT
fi &&
    if [ -f /home/user/extension/init.user.sh ]
    then
        sh /home/user/extension/init.user.sh "${@}"
    fi &&
    PROJECT_NAME="${PROJECT_NAME}" node /home/user/c9sdk/server.js --listen 0.0.0.0 -w /home/user/workspace -p ${CLOUD9_PORT} &&
    shift ${#}
