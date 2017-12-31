#!/bin/sh

if [ -f /opt/docker/extension/cleanup.sh ]
then
    cleanup() {
        sh /opt/docker/extension/cleanup.sh
    } &&
    trap cleanup EXIT
fi &&
    if [ -f /opt/docker/extension/init.root.sh ]
    then
        sudo sh /opt/docker/extension/init.root.sh
    fi &&
    if [ -f /opt/docker/extension/user.sudo ]
    then
        cat /opt/docker/extension/user.sudo | sudo tee /etc/sudoers.d/user
    else
        sudo rm /etc/sudoers.d/user
    fi &&
    if [ -f /opt/docker/extension/init.user.sh ]
    then
        sh /opt/docker/extension/init.user.sh "${@}"
    fi &&
    PROJECT_NAME="${PROJECT_NAME}" node /opt/docker/c9sdk/server.js --listen 0.0.0.0 -w /opt/docker/workspace -p ${CLOUD9_PORT} &&
    shift ${#}
