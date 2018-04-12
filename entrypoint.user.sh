#!/bin/sh

if [ -f /opt/cloud9/extension/cleanup.user.sh ]
then
    cleanup() {
        sh /opt/cloud9/extension/cleanup.user.sh
    } &&
    trap cleanup EXIT
fi &&
    if [ -f /opt/cloud9/extension/init.user.sh ]
    then
        sh /opt/cloud9/extension/init.user.sh "${@}"
    fi &&
    if [ -f /opt/cloud9/extension/post.user.sh ]
    then
        nohup sh /opt/cloud9/extension/post.user.sh &
    fi &&
    PROJECT_NAME="${PROJECT_NAME}" node /opt/cloud9/c9sdk/server.js --listen 0.0.0.0 -w ${CLOUD9_WORKSPACE} -p ${CLOUD9_PORT} &&
    shift ${#}
