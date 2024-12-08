pkg install -y bastille
sysrc bastille_list=
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_tzdata="Europe/Berlin"
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_zfs_enable="YES"
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_zfs_zpool="work"
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_network_loopback="localnet0"
bastille bootstrap 14.1-RELEASE update
# bastille create JAILNAME 14.1-RELEASE 10.0.0.2 localnet0
# bastille create -B JAILNAME 14.1-RELEASE 0.0.0.0 publicnet0
# bastille start JAILNAME
