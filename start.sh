#!/bin/bash


LISTEN_PORT=${LISTEN_PORT:-8181}
sed -e "s/port: 8181/port: $LISTEN_PORT/" -i /etc/snap/snapd.conf

function getNodeName {
  NODE_NAME=${NODE_NAME:-$(hostname)}
  echo $NODE_NAME | sed -e "s/\./_/g"
}

if [ "$(ls -A /opt/snap/tasks/)" ]; then
  for t in /opt/snap/tasks/*; do
  	log "loading task from $t"
    sed -e "s/<%NODE%>/$(getNodeName)/g" -i $t
  done
fi

# run SNAPD
exec /opt/snap/bin/snapd -t ${SNAP_TRUST_LEVEL} -l ${SNAP_LOG_LEVEL} -o ''
