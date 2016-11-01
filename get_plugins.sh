#!/bin/bash

set -x
# Find the directory we exist within
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

mkdir -p tmp/
mkdir -p plugins/
cd plugins

for p in collector-cpu collector-docker collector-interface collector-iostat collector-load collector-meminfo publisher-graphite; do
  curl -sfL https://s3-us-west-2.amazonaws.com/snap.ci.snap-telemetry.io/plugins/snap-plugin-$p/latest/linux/x86_64/snap-plugin-$p -o snap-plugin-$p
done
