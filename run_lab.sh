#!/bin/bash

PREFIX=${PWD##*/}
# Set up the topology
docker-compose up -d
# Copy setup scripts to the emulators
docker cp setup_hv1.sh ${PREFIX}_hv1_1:/
docker cp setup_hv2.sh ${PREFIX}_hv2_1:/
# Execute the setup script on the emulators
docker exec ${PREFIX}_hv1_1 /setup_hv1.sh
docker exec ${PREFIX}_hv2_1 /setup_hv2.sh
# Start capturing packets on overlay and underlay network
docker exec -d ${PREFIX}_hv1_1 /bin/bash -c "tcpdump -i vm1 -w vm1_overlay.pcap"
docker exec -d ${PREFIX}_hv2_1 /bin/bash -c "tcpdump -i vm2 -w vm2_overlay.pcap"
docker exec -d ${PREFIX}_hv1_1 /bin/bash -c "tcpdump -i eth0 -w vm1_underlay.pcap"
docker exec -d ${PREFIX}_hv2_1 /bin/bash -c "tcpdump -i eth0 -w vm2_underlay.pcap"
# Ping from VM1 to VM2
docker exec ${PREFIX}_hv1_1 /bin/bash -c "ping -I vm1 -c 1 192.168.1.2"
# Wait for the packets to be captured
sleep 1
# Kill the tcpdump process
docker exec ${PREFIX}_hv1_1 /bin/bash -c "pkill tcpdump"
docker exec ${PREFIX}_hv2_1 /bin/bash -c "pkill tcpdump"
# Collect *.pcap files
docker cp ${PREFIX}_hv1_1:/vm1_overlay.pcap .
docker cp ${PREFIX}_hv2_1:/vm2_overlay.pcap .
docker cp ${PREFIX}_hv1_1:/vm1_underlay.pcap .
docker cp ${PREFIX}_hv2_1:/vm2_underlay.pcap .
# Clean up
docker-compose kill
docker-compose rm -f
