#!/bin/bash

gitdirsdir=/home/hexstream/d2/gitdirs/
gitdirsfile="${gitdirsdir}gitdirs.txt"

rm -rf ${gitdirsdir}data/

cd /home/hexstream/

find data/ -name .git > $gitdirsfile

cd $gitdirsdir

for gitdir in $(cat $gitdirsfile); do
    dir=$(dirname $gitdir);
    dir+="/";
    mkdir -p $dir
    ln -s /home/hexstream/$gitdir $gitdir
done
