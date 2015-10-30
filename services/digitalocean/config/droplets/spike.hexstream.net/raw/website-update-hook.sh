#!/bin/bash

source ~/scripts/website-env.sh

declare -x PUBLIC=/home/${WEBSITE:?}/public/

cd ~/website.git/

GIT_WORK_TREE=$PUBLIC git checkout -f

# Remove canonical self-links in production
sed -i -e '/<nav id="meta-nav"/{n;N;N;s/.*[Cc]anonical.*/<delete>/;
}; /<delete>/d' $(find $PUBLIC -name '*.html')

aws s3 sync $PUBLIC s3://$WEBSITE/ --delete



# Make sure all files without an extension are served as text. (Good enough heuristic, for now.)

cd $PUBLIC

for FILE in $(find . -type f ! -name '*.*');
do aws s3 cp s3://$WEBSITE/${FILE:2} s3://$WEBSITE/${FILE:2} --content-type 'text/plain' --metadata-directive REPLACE;
done
