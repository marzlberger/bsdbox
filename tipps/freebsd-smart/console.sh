# https://bsdbox.de/artikel/tipps/freebsd-smart
pkg install -y smartmontools
sysrc -f /etc/periodic.conf daily_status_smart_devices="YES"
service smartd enable
echo "DEVICESCAN -a -n standby -W 4,30,40 -m root -s (S/../../7/01|L/../01/./00)" > /usr/local/etc/smartd.conf
service smartd start
