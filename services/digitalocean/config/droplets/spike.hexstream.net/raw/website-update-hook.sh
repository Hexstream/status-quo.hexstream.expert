#!/bin/bash

source ~/scripts/website-env.sh

declare -x PUBLIC=/home/${WEBSITE:?}/public/
CACHE_CONTROL='max-age=86400'

cd ~/website.git/

GIT_WORK_TREE=$PUBLIC git checkout -f

aws s3 sync $PUBLIC s3://$WEBSITE/ --delete --cache-control "$CACHE_CONTROL"



# Make sure all files without an extension are served as text. (Good enough heuristic, for now.)

cd $PUBLIC

for FILE in $(find . -type f ! -name '*.*' -o -name '.?*');
do aws s3 cp s3://$WEBSITE/${FILE:2} s3://$WEBSITE/${FILE:2} --content-type 'text/plain' --cache-control "$CACHE_CONTROL" --metadata-directive REPLACE;
done
