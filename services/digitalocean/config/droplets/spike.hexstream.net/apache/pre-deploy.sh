#!/bin/bash

DIR=$PRE_DEPLOY_DIR/apache

echo Pre-deploying to $DIR...

rm -rf $DIR
mkdir $DIR

mkdir $DIR/public/
cp -rT /home/status-quo.hexstreamsoft.com/public/services/digitalocean/config/droplets/spike.hexstream.net/apache/ $DIR/public/

mkdir $DIR/private/
cp -rT /home/private.status-quo.hexstream.xyz/public/apache/ $DIR/private/

rm $DIR/public/*.sh

sed -i "s/\$HOME_IP/$(dig +short hq.hexstream.xyz)/" $DIR/public/site-wide-tunnels.conf

echo Done.
