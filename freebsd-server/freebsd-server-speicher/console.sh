gpart destroy -F ada0
gpart destroy -F ada1
gpart destroy -F ada2
gpart destroy -F ada3
gpart destroy -F ada4
gpart destroy -F ada5
gpart create -s gpt ada0
gpart create -s gpt ada1
gpart create -s gpt ada2
gpart create -s gpt ada3
gpart create -s gpt ada4
gpart create -s gpt ada5
SNADA0=`camcontrol identify ada0 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SNADA1=`camcontrol identify ada1 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SNADA2=`camcontrol identify ada2 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SNADA3=`camcontrol identify ada3 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SNADA4=`camcontrol identify ada4 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
SNADA5=`camcontrol identify ada5 | sed -n 's/.*serial number.*\(.\{4\}\)$/\1/p'`
gpart add -t freebsd-zfs  -l "$SNADA0" -a 4K "ada0"
gpart add -t freebsd-zfs  -l "$SNADA1" -a 4K "ada1"
gpart add -t freebsd-zfs  -l "$SNADA2" -a 4K "ada2"
gpart add -t freebsd-zfs  -l "$SNADA3" -a 4K "ada3"
gpart add -t freebsd-zfs  -l "$SNADA4" -a 4K "ada4"
gpart add -t freebsd-zfs  -l "$SNADA5" -a 4K "ada5"
zpool create -o /mnt/data data raidz2 /dev/gpt/$SNADA0 /dev/gpt/$SNADA1 /dev/gpt/$SNADA2 /dev/gpt/$SNADA3
zpool create -o /mnt/work work mirror /dev/gpt/$SNADA4 /dev/gpt/$SNADA5
zfs set compression=lz4 atime=off xattr=sa acltype=posixacl data
zfs set compression=lz4 atime=off xattr=sa acltype=posixacl work
zpool status data work
