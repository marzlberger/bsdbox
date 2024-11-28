ee /usr/local/etc/monitrc
	check program zfs_health with path "/root/zfs_health_check.sh"
		if status != 0 then alert
ee /root/zfs_health_check.sh
    #! /bin/sh
    /usr/bin/printf "%s\n\n" "$(/sbin/zfs list -o name,avail,used -d 0)"
    /usr/bin/printf "%s\n\n" "$(/sbin/zpool list -o name,size,allocated,free,capacity,health)"
    LISTPOOLS="$(/sbin/zpool list -H -o name)"
    for POOL in ${LISTPOOLS}; do
      HEALTH="$(/sbin/zpool list -H -o health ${POOL})"
      ERROR="$(/sbin/zpool status ${POOL} | grep errors: | awk '{print $2}')"
      if [ ${HEALTH} != ONLINE ]; then
        exit 1
      fi
      if [ ${ERROR} != "No" ]; then
        exit 1
      fi
    done
chmod +x /root/zfs_health_check.sh
service monit restart
