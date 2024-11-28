pkg install -y dma
sysrc -f /etc/periodic.conf daily_clean_hoststat_enable="NO"
sysrc -f /etc/periodic.conf daily_status_mail_rejects_enable="NO"
sysrc -f /etc/periodic.conf daily_status_include_submit_mailq="NO"
sysrc -f /etc/periodic.conf daily_submit_queuerun="NO"
sysrc -f /etc/periodic.conf daily_scrub_zfs_enable="YES"
sysrc -f /etc/periodic.conf daily_trim_zfs_enable="YES"
sysrc -f /etc/periodic.conf daily_status_zfs_enable="YES"
ee /etc/dma/dma.conf
    SMARTHOST MAILSERVER
    PORT 587
    AUTHPATH /etc/dma/auth.conf
    SECURETRANSFER
    STARTTLS
    MASQUERADE FROM-EMAIL
ee /etc/dma/auth.conf
    LOGIN|MAILSERVER:PASSWORT
chown root:mail /etc/dma/auth.conf
chmod 660 /etc/dma/auth.conf
ee /etc/aliases
    root:   TO-EMAIL
echo Testmessage | mail -v -s Testbetreff TO-EMAIL
