#!/bin/sh

sudo apt-get update
sudo apt-get install -y ant autoconf automake build-essential debhelper fakeroot git graphviz help2man libssl-dev libtool maven python-all python-paramiko python-pip python-qt4 python-setuptools python-sphinx python-twisted-conch quagga tmux vim
sudo pip install alabaster jprops pick pytest requests
sudo apt-get install -y software-properties-common python-software-properties

# Install OVS
wget http://openvswitch.org/releases/openvswitch-2.8.1.tar.gz
tar -xvzf openvswitch-2.8.1.tar.gz
cd openvswitch-2.8.1/
sudo ./configure --with-linux=/lib/modules/$(uname -r)/build
sudo make
sudo make install
sudo make modules_install
sudo /sbin/modprobe openvswitch
sudo /sbin/lsmod | grep openvswitch
sudo mkdir -p /usr/local/etc/openvswitch
sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema
sudo mkdir -p /usr/local/var/run/openvswitch

sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock     --remote=db:Open_vSwitch,Open_vSwitch,manager_options     --private-key=db:Open_vSwitch,SSL,private_key     --certificate=db:Open_vSwitch,SSL,certificate     --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert     --pidfile --detach --log-file

sudo ovs-vsctl --no-wait init

sudo ovs-vswitchd --pidfile --detach --log-file

sudo /usr/local/share/openvswitch/scripts/ovs-ctl --system-id=random start