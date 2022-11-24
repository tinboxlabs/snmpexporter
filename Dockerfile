FROM python:3.8-alpine

RUN apk add --update gcc net-snmp-tools net-snmp-dev musl-dev make findutils wget
  #pip3 install python3-netsnmp --pre && \
  #pip3 install coverage pyyaml twisted objgraph


RUN (mkdir -p /var/lib/mibs/std /tmp/librenms; cd /tmp/librenms; \
  wget -q https://github.com/librenms/librenms/archive/master.zip 2>&1 && \
  unzip master.zip && mv librenms-master/mibs/* /var/lib/mibs/std/) && \
  rm -r /tmp/librenms

ADD etc/snmp.conf /etc/snmp/

ADD . /tmp/snmpexporter
RUN pip3 install -r /tmp/snmpexporter/requirements.txt
RUN make install -C /tmp/snmpexporter && ls -laR /opt

EXPOSE 9190
CMD ["/opt/snmpexporter/snmpexporterd.py", \
  "--config", "/etc/snmpexporter/snmpexporter.yaml"]
