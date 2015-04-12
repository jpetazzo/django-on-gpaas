#!/bin/sh
if ! [ -f credentials.gandi ]; then
    echo "Create the 'credentials.gandi' file to define UID, PASSWORD, and GITHOST"
    echo "Example:"
    echo "cat >credentials.gandi <<EOF"
    echo "LOGIN=123456"
    echo "PASSWORD=ABCD1234"
    echo "GITHOST=git.dc1.gpaas.net"
    echo "EOF"
    exit 1
fi
. ./credentials.gandi
git remote | grep -q ^gandi$ || git remote add gandi ssh+git://$LOGIN@$GITHOST/default.git
git push -f gandi master
ssh $LOGIN@$GITHOST "deploy default"


