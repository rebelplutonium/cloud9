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
    if [ ! -d ${CLOUD9_WORKSPACE} ]
    then
        mkdir ${CLOUD9_WORKSPACE} &&
            chown -R user:user ${CLOUD9_WORKSPACE}
    fi &&
    if [ -f /opt/cloud9/extension/post.root.sh ]
    then
        nohup sh /opt/cloud9/extension/post.root.sh &
    fi &&
    su -c "sh /opt/cloud9/scripts/entrypoint.user.sh" user
