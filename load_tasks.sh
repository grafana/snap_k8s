#!/bin/bash

PPID=$1

# log messages to our parent PIDS stdout
function log {
	echo $@ >> /proc/$PPID/fd/1
}

function wait_for_snap {
  while true; do
    log "waiting for snap api to be ready..."
    host=localhost
    port=8181
    nc -z $host $port && echo "snapd is ready!" && break
    sleep 1
  done
}

function getHostname {
  hostname | sed -e "s/\./_/g"
}

wait_for_snap

if [ "$(ls -A /opt/snap/tasks)" ]; then
  for t in /opt/snap/tasks/*; do
  	log "loading task from $t"
    sed -e "s/<%NODE%>/$(getHostname)/g" $t > /tmp/$(basename $t)
    log $(snapctl task create -t /tmp/$(basename $t) 2>&1 )
  done
fi

log "Task loading complete"