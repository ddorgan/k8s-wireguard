#!/bin/bash
apt-get update
apt-get -y install dialog apt-utils software-properties-common linux-headers-$(uname --kernel-release)
add-apt-repository -y ppa:wireguard/wireguard
apt-get -y install wireguard
modprobe wireguard

