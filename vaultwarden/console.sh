mkdir -p /usr/local/etc/pkg/repos
sed -e 's|quarterly|latest|g' /etc/pkg/FreeBSD.conf > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update
pkg install -y vaultwarden libargon2
service vaultwarden enable
install -o www -g www -d /usr/local/www/vaultwarden/data/ssl/
openssl req -new -x509 -days 3650 -nodes -keyout /usr/local/www/vaultwarden/data/ssl/vault.key -out /usr/local/www/vaultwarden/data/ssl/vault.crt -subj "/C=DE/ST=NRW/L=ERKRATH/O=BSDBOX/OU=IT/CN=vault.bsdbox.local"
chown www:www /usr/local/www/vaultwarden/data/ssl/*
# Optional: install -o www -g www -d /usr/local/www/vaultwarden/data/rc.conf.d
# Optional: ln -sf /usr/local/www/vaultwarden/data/rc.conf.d /usr/local/etc/rc.conf.d
cat > /usr/local/etc/rc.conf.d/vaultwarden << EOF
ROCKET_ADDRESS=0.0.0.0
export ROCKET_ADDRESS
ROCKET_PORT=8000
export ROCKET_PORT
ROCKET_TLS='{certs = "/usr/local/www/vaultwarden/data/ssl/vault.crt", key = "/usr/local/www/vaultwarden/data/ssl/vault.key"}'
export ROCKET_TLS
ADMIN_TOKEN=`openssl rand -base64 48 > admintoken.pwd && chmod 600 admintoken.pwd && echo $ADMINTOKEN | argon2 "$(openssl rand -base64 32)" -e -id -k 65540 -t 3 -p 4`
export ADMIN_TOKEN
DOMAIN=https://`hostname -f`
export DOMAIN
SIGNUPS_ALLOWED=true
export SIGNUPS_ALLOWED
ORG_GROUPS_ENABLED=true
export ORG_GROUPS_ENABLED
EOF
service vaultwarden start
echo "Admintoken in: admintoken.pwd"
echo "Admin: https://`hostname -f`/admin:8000"
