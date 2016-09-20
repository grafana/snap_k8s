FROM raintank/snap:xenial

RUN apt-get update && apt-get -y install netcat-traditional sysstat

COPY plugins/* /opt/snap/plugins/
COPY snapd.conf /etc/snap/snapd.conf

RUN chmod a+x /opt/snap/plugins/*

COPY start.sh /usr/local/bin
COPY load_tasks.sh /usr/local/bin
RUN mkdir /opt/snap/tasks

CMD /usr/local/bin/start.sh
