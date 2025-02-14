#!/usr/bin/env bash
release_dir=$1

find $release_dir -type f ! -name '*.md5' -execdir sh -c 'md5sum "$1" > "../$1.md5"' _ {} \;

cat *.md5
rm *.md5


