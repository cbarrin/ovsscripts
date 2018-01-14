#!/bin/sh

# Start OVS
sudo /usr/local/share/openvswitch/scripts/ovs-ctl --system-id=random start
sudo ovs-vsctl --version
