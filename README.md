# vxlan-lab

See [VXLAN Hands on Lab](http://hechao.li/2018/05/15/VXLAN-Hands-on-Lab/)

# Prerequisite 
* Docker
* docker-compose

# Run
```bash
$ ./run_lab.sh
```

# Collect PCAP file
After running `run_lab.sh`, the PCAP files are generated and copied to working directory
```bash
$ ls *.pcap
vm1_overlay.pcap  vm1_underlay.pcap vm2_overlay.pcap  vm2_underlay.pcap
```
