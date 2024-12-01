# https://bsdbox.de/artikel/freebsd-server/freebsd-server-speicher
# ada0 - ada3 = raidz2 "data"
# ada4 - ada5 = mirror "work"

# Startover: zpool destroy data
# Startover: zpool destroy work
DEVICELIST="ada0 ada1 ada2 ada3 ada4 ada5" # Check with camcontrol devlist first
for DEVICE in $DEVICELIST; do gpart destroy -F $DEVICE; done
for DEVICE in $DEVICELIST; do gpart create -s gpt $DEVICE && gpart add -t freebsd-zfs -l "$(camcontrol identify $DEVICE | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p')" -a 4K "$DEVICE"; done

SERIAL0=`camcontrol identify ada0 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SERIAL1=`camcontrol identify ada1 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SERIAL2=`camcontrol identify ada2 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SERIAL3=`camcontrol identify ada3 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SERIAL4=`camcontrol identify ada4 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SERIAL5=`camcontrol identify ada5 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`

zpool create -f -m /mnt/data data raidz2 /dev/gpt/$SERIAL0 /dev/gpt/$SERIAL1 /dev/gpt/$SERIAL2 /dev/gpt/$SERIAL3
zpool create -f -m /mnt/work work mirror /dev/gpt/$SERIAL4 /dev/gpt/$SERIAL5
zfs set compression=lz4 atime=off xattr=sa acltype=posixacl data
zfs set compression=lz4 atime=off xattr=sa acltype=posixacl work
sysrc -f /etc/periodic.conf daily_scrub_zfs_enable="YES"
sysrc -f /etc/periodic.conf daily_trim_zfs_enable="YES"
sysrc -f /etc/periodic.conf daily_status_zfs_enable="YES"

glabel list | grep -E "Geom name|1\. Name: gpt" | awk -F": " '/Geom name/ {geom=$2}/1\. Name/ {name=$2; print geom " = " name}' | sort
zpool status data work
zpool list data work
