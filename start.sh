#!/bin/bash

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
exec $@
