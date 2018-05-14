#!/bin/bash

# Start OVSDB server
ovsdb-server --pidfile --detach --log-file \
--remote punix:/usr/local/var/run/openvswitch/db.sock \
--remote=db:hardware_vtep,Global,managers \
/usr/local/etc/openvswitch/ovs.db /usr/local/etc/openvswitch/vtep.db
# Start ovs-vswitchd
ovs-vswitchd --log-file --pidfile --detach \
unix:/usr/local/var/run/openvswitch/db.sock
