#!/usr/bin/env sh

if [ "$(id -u)" -eq 0 ]
then
  service zram-swap-config stop
  systemctl disable zram-swap-config
  rm /etc/systemd/system/zram-swap-config.service
  rm /usr/local/bin/zram-swap-config
  #rm /usr/local/bin/zram-swap-config-slb
  #rm /usr/local/bin/zram-swap-config-slb-pid
  rm /etc/zram-swap-config.conf
  
  echo "zram-swap-config is uninstalled, removing the uninstaller in progress"
  rm /usr/local/bin/zram-swap-config-uninstall.sh
  echo "##### Reboot isn't needed #####"
else
  echo "You need to be ROOT (sudo can be used)"
fi
