# https://bsdbox.de/artikel/tipps/freebsd-netzwerk
sysrc cloned_interfaces="bridge0 lo1"
sysrc ifconfig_bridge0_name="publicnet0"
sysrc ifconfig_lo1_name="localnet0"
sysrc ifconfig_publicnet0="addm igb0 up"
sysrc ifconfig_localnet0="inet 10.0.0.1/24"
service gateway enable
service netif restart
