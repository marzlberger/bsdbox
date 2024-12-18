# https://bsdbox.de/artikel/tipps/freebsd-firewall
EXTIF=`route -n get default | grep 'interface:' | grep -o '[^ ]*$'`
cat > /etc/pf.conf << EOF
ext_if="${EXTIF}"
set block-policy return
scrub in on $ext_if all fragment reassemble
set skip on lo
table <jails> persist
table <vms> persist
nat on $ext_if from <jails> to any -> ($ext_if:0)
nat on $ext_if from <vms> to any -> ($ext_if:0)
rdr-anchor "rdr/*"
block in all
pass out quick keep state
antispoof for $ext_if} inet
pass in inet proto icmp
pass in inet proto tcp from any to any port ssh flags S/SA keep state
EOF
service pf enable
service pf start
