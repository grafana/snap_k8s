#!/bin/bash


LISTEN_PORT=${LISTEN_PORT:-8181}
sed -e "s/port: 8181/port: $LISTEN_PORT/" -i /etc/snap/snapteld.conf

function getNodeName {
  NODE_NAME=${NODE_NAME:-$(hostname)}
  echo $NODE_NAME | sed -e "s/\./_/g"
}

if [ "$(ls -A /opt/snap/tasks/)" ]; then
  mkdir /opt/snap/tasks_startup
  for t in /opt/snap/tasks/*.{yaml,yml,json}; do
  	if [ -f "$t" ]; then
	  	echo "loading task from $t"
	    #sed -e "s/<%NODE%>/$(getNodeName)/g" -i $t
	    sed -e "s/<%NODE%>/$(getNodeName)/g" $t >/opt/snap/tasks_startup/$(basename $t)
	fi
  done
fi

# run SNAPTELD
exec /opt/snap/sbin/snapteld -t ${SNAP_TRUST_LEVEL} -l ${SNAP_LOG_LEVEL} -o ''
