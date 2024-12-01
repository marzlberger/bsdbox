# https://bsdbox.de/artikel/tipps/freebsd-motd
sysrc update_motd="NO"
cp /usr/local/share/examples/dynamic_motd/rc.motd /usr/local/etc/rc.motd
cp /usr/local/share/examples/dynamic_motd/motd.subr /usr/local/etc/motd.subr
service dynamic_motd enable
service dynamic_motd start
