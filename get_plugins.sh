#!/bin/bash

set -x
# Find the directory we exist within
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

VERSION=${VERSION:-v0.16.1-beta}

mkdir -p tmp/
mkdir -p plugins/
cd tmp
if [ ! -d snap-${VERSION}/plugin ]; then
    wget https://github.com/intelsdi-x/snap/releases/download/${VERSION}/snap-plugins-${VERSION}-linux-amd64.tar.gz
    ar -zxf snap-plugins-${VRESION}-linux-amd64.tar.gz
fi

for p in collector-cpu collector-docker collector-interface collector-iostat collector-load collector-meminfo publisher-graphite; do
    cp snap-${VERSION}/plugin/snap-plugin-$p $DIR/plugins/
done


