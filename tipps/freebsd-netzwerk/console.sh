# https://bsdbox.de/artikel/tipps/freebsd-netzwerk
INTERFACE=`route -n get default | grep 'interface:' | grep -o '[^ ]*$'`
sysrc cloned_interfaces="bridge0 lo1"
sysrc ifconfig_bridge0_name="publicnet0"
sysrc ifconfig_lo1_name="localnet0"
sysrc ifconfig_publicnet0="addm ${INTERFACE} up"
sysrc ifconfig_localnet0="inet 10.0.0.1/24"
sysrc gateway_enable="YES"
service netif restart
