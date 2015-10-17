#!/bin/bash

DIR=$PRE_DEPLOY_DIR/apache

rm -rf $DIR
mkdir $DIR

cp -rT /home/status-quo.hexstreamsoft.com/public/services/digitalocean/config/droplets/spike.hexstream.net/apache/ $DIR

rm $DIR/*.sh

sed -i "s/\$HOME_IP/$(dig +short hq.hexstream.xyz)/" $DIR/site-wide-tunnels.conf
