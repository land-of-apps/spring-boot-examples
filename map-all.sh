#!/usr/bin/env bash

set -x
for f in */map.sh; do
  (cd $(dirname $f); ./map.sh)
done
