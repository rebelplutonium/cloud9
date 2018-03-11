#!/bin/sh

if [ -f /opt/cloud9/extension/cleanup.root.sh ]
then
    cleanup() {
        sh /opt/cloud9/extension/cleanup.root.sh
    } &&
    trap cleanup EXIT
fi &&
    if [ -f /opt/cloud9/extension/parse.sh ]
    then
        sh /opt/cloud9/extension/parse.sh "${@}"
    fi &&
    shift ${#} &&
    if [ -f /opt/cloud9/extension/init.root.sh ]
    then
        sh /opt/cloud9/extension/init.root.sh
    fi &&
    if [ ! -d /opt/cloud9/workspace ]
    then
        mkdir /opt/cloud9/workspace &&
            chown -R user:user /opt/cloud9/workspace
    fi &&
    su -c "sh /opt/cloud9/scripts/entrypoint.user.sh" user
