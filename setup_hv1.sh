#!/bin/bash

# Add a switch br0
ovs-vsctl add-br br0
# Add a port vm1 to br0
ovs-vsctl add-port br0 vm1 -- set interface vm1 type=internal
# Set the vm1's MAC address
ifconfig vm1 hw ether 00:00:00:00:00:01
# Set the vm1's IP address
ifconfig vm1 192.168.1.1 netmask 255.255.255.0 up
# Add br0 to vtep database
vtep-ctl add-ps br0
# Set the underlay tunnel IP to be eth0's IP
vtep-ctl set Physical_Switch br0 tunnel_ips=10.0.0.1
# Start VTEP emulator
/usr/local/share/openvswitch/scripts/ovs-vtep --log-file --pidfile --detach br0
sleep 1
# Add Logical switch ls0
vtep-ctl add-ls ls0
# Set VXLAN ID of ls0 to 5000
vtep-ctl set Logical_Switch ls0 tunnel_key=5000
# Binding ls0 to port vm1 with VLAN 0
vtep-ctl bind-ls br0 vm1 0 ls0
# Add remote VM2's MAC address and physical locator
vtep-ctl add-ucast-remote ls0 00:00:00:00:00:02 10.1.0.1
# Trick, add hypervisor 2's tunnel endpoint IP as locator to unknown dst
vtep-ctl add-mcast-remote ls0 unknown-dst 10.1.0.1
