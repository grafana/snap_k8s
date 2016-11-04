FROM intelsdi/snap:xenial

RUN apt-get update && apt-get -y install netcat-traditional sysstat curl

ENV PLUGIN_URL=https://s3-us-west-2.amazonaws.com/snap.ci.snap-telemetry.io/plugins

RUN for p in collector-cpu collector-docker collector-interface collector-iostat collector-load collector-meminfo publisher-graphite; do \
  curl -sfL $PLUGIN_URL/snap-plugin-$p/latest/linux/x86_64/snap-plugin-$p -o /opt/snap/plugins/snap-plugin-$p ; done

COPY snapd.conf /etc/snap/snapd.conf

RUN chmod a+x /opt/snap/plugins/*

COPY start.sh /usr/local/bin
RUN mkdir /opt/snap/tasks
RUN chmod a+x /opt/snap/tasks

RUN chmod a+x /opt/snap/bin/*
CMD /usr/local/bin/start.sh
