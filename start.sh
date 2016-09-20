#!/bin/bash

## run a background process to load our tasks once snapd is ready
MYPID=$$
nohup /usr/local/bin/load_tasks.sh $MYPID >/dev/null &

# run SNAPD
exec /opt/snap/bin/snapd -t ${SNAP_TRUST_LEVEL} -l ${SNAP_LOG_LEVEL} -o ''
