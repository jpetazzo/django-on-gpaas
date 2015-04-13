#!/bin/sh
if ! [ -f credentials.gandi ]; then
    echo "Create the 'credentials.gandi' file to define UID, PASSWORD, and GITHOST"
    echo "Example:"
    echo "cat >credentials.gandi <<EOF"
    echo "LOGIN=123456"
    echo "PASSWORD=ABCD1234"
    echo "DC=dc1"
    echo "EOF"
    exit 1
fi
. ./credentials.gandi

case $1 in
console)
    ssh $LOGIN@console.$DC.gpaas.net
    ;;
deploy)
    if git status --porcelain | grep -q ^. ; then
	echo "You have uncommitted changes. If you really want to push, use 'forcedeploy'."
	exit 1
    fi
    "$0" forcedeploy
    ;;
forcedeploy)
    git remote | grep -q ^gandi$ || git remote add gandi ssh+git://$LOGIN@git.$DC.gpaas.net/default.git
    git push -f gandi master
    ssh $LOGIN@git.$DC.gpaas.net "deploy default"
    ;;
logs)
    echo "cd /lamp0/var/log/www/" > get-logs.sftp
    echo "get uwsgi.log" >> get-logs.sftp
    sftp -b get-logs.sftp $LOGIN@git.$DC.gpaas.net
    tail -n 50 uwsgi.log
    rm get-logs.sftp
    ;;
*)
    echo "Specify one command: console, deploy, forcedeploy, logs."
    ;;
esac


