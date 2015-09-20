#!/bin/bash

set -e

cp /vagrant/feeds.conf .

# make dirclean
[ -f .config ] && rm .config
make defconfig
make clean
git pull --ff-only
scripts/feeds clean -a
scripts/feeds update -a
scripts/feeds install -a
scripts/feeds uninstall openconnect
scripts/feeds uninstall vpnc-scripts
scripts/feeds install -a -p custom
scripts/feeds uninstall vpnc-scripts

cat /vagrant/chaos-calmer-gateway.diffconfig > .config
make defconfig
make -j9 || make -j9 || make -j9

grep openwrt-ar71xx-generic-wndr3700v2-squashfs-sysupgrade.bin bin/ar71xx/md5sums
