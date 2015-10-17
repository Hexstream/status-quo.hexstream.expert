#!/bin/bash

cd /etc/apache2/

rm -rf custom
cp -r $PRE_DEPLOY_DIR/apache/ custom

apache2ctl graceful
