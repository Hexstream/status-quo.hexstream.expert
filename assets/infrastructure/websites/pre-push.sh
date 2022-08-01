#!/bin/sh

IFS=' '
while read local_ref local_sha remote_ref remote_sha
do
    if [ "$remote_ref" = "refs/heads/live" ]
    then
        wrangler pages publish public;
    fi
done

exit 0
