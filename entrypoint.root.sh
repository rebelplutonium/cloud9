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
    if [ -f /opt/cloud9/extension/user.sudo ]
    then
        cat /opt/cloud9/extension/user.sudo > /etc/sudoers.d/user &&
            chmod 0444 /etc/sudoers.d/user
    fi &&
    su -c "sh /opt/cloud9/scripts/entrypoint.user.sh" user
