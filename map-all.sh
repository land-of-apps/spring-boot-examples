#!/usr/bin/env bash

set -x
for f in */map.sh; do
  (cd $(dirname $f); ./map.sh)
done

find tmp/appmap -ls
for f in $(find tmp/appmap -name \*appmap.json); do
  cat $f | jq .
done
