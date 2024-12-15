# https://bsdbox.de/artikel/tipps/freebsd-monit-zfs
ee /usr/local/etc/monitrc
	check program zfs_health with path "/root/zfs_health_check.sh"
		if status != 0 then alert
ee /root/zfs_health_check.sh
	#! /bin/sh
	/usr/bin/printf "%s\n\n"
	/usr/bin/printf "%s\n\n" "$(/sbin/zpool list -o name,size,allocated,free,capacity,health)"
	ERROR_DETAILS=""
	LISTPOOLS="$(/sbin/zpool list -H -o name)"
	for POOL in ${LISTPOOLS}; do
	  HEALTH="$(/sbin/zpool list -H -o health ${POOL})"
	  ERROR="$(/sbin/zpool status ${POOL} | grep errors: | awk '{print $2}')"
	  if [ "${HEALTH}" != "ONLINE" ]; then
	    ERROR_DETAILS="${ERROR_DETAILS} ${POOL}: Zustand ist ${HEALTH} (erwartet: ONLINE)"
	  fi
	  if [ "${ERROR}" != "No" ]; then
	    ERROR_DETAILS="${ERROR_DETAILS} ${POOL}: Fehlerstatus ist ${ERROR} (erwartet: No)"
	  fi
	done
	if [ -n "${ERROR_DETAILS}" ]; then
	  MISSING_DETAILS="$(/sbin/zpool status -x -e)"
	  /usr/bin/printf "%s\n" "${MISSING_DETAILS}"
	  exit 1
	else
	  exit 0
	fi
chmod +x /root/zfs_health_check.sh
service monit restart
