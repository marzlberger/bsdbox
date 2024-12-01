pkg install -y monit
service monit enable
ee /usr/local/etc/monitrc
	set daemon 120 with start delay 60
	set log syslog
	set httpd unixsocket /var/run/monit.sock
		allow localhost
	set mailserver MAILSERVER port 587 username LOGIN password "PASSWORT" using ssl with options { version: auto verify: enable }
	set alert TO-EMAIL mail-format { from: FROM-EMAIL } reminder on 10 cycles
	check system $HOST
	   if memory usage is greater than 75% then alert 
	   if cpu usage is greater than 75% then alert 
	   if loadavg (1min) is greater than 8 then alert 
	   if loadavg (5min) is greater than 6 then alert 
	check filesystem RootZFS with path "/"
	   if space usage is greater than 75% then alert 
	check filesystem DataZFS with path "/mnt/data"
	   if space usage is greater than 75% then alert 
	check filesystem WorkZFS with path "/mnt/work"
	   if space usage is greater than 75% then alert 
chmod 600 /usr/local/etc/monitrc
service monit start
