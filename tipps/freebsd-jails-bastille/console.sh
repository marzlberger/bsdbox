pkg install -y bastille
service bastille enable
sysrc bastille_rcorder=YES
sysrc bastille_list=
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_tzdata="Europe/Berlin"
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_zfs_enable="YES"
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_zfs_zpool="work"
sysrc -f /usr/local/etc/bastille/bastille.conf bastille_network_loopback="localnet0"
bastille bootstrap XX.Y-RELEASE update
# OPTIONAL: zfs create -o mountpoint=/usr/local/bastille/data data/bastille
# bastille create JAILNAME XX.Y-RELEASE 10.0.0.2 localnet0
# bastille create -B JAILNAME XX.Y-RELEASE 0.0.0.0 publicnet0
# bastille start JAILNAME
