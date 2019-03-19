#!/usr/bin/env sh

systemctl -q is-active zram-swap-config  && { echo "ERROR: zram-swap-config service is still running. Please run \"sudo service zram-swap-config stop\" to stop it."; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "You need to be ROOT (sudo can be used)"; exit 1; }

# zram-swap-config
mkdir -p /usr/local/bin/
install -m 644 zram-swap-config.service /etc/systemd/system/zram-swap-config.service
install -m 755 zram-swap-config /usr/local/bin/zram-swap-config
install -m 644 zram-swap-config.conf /etc/zram-swap-config.conf
install -m 644 uninstall.sh /usr/local/bin/zram-swap-config-uninstall.sh
systemctl enable zram-swap-config


echo "#####     Reboot to activate zram-swap-config     #####"
echo "##### edit /etc/zram-swap-config.conf for options #####"
