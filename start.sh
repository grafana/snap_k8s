#!/bin/bash

## run a background process to load our tasks once snapd is ready
MYPID=$$
nohup /usr/local/bin/load_tasks.sh $MYPID >/dev/null &

LISTEN_PORT=${LISTEN_PORT:-8181}
sed -e "s/port: 8181/port: $LISTEN_PORT/" -i /etc/snap/snapd.conf

# run SNAPD
exec /opt/snap/bin/snapd -t ${SNAP_TRUST_LEVEL} -l ${SNAP_LOG_LEVEL} -o ''
