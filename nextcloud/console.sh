pkg update
pkg install -y nextcloud-php84 nextcloud-appointments-php84 nextcloud-calendar-php84 nextcloud-contacts-php84 nextcloud-deck-php84 nextcloud-forms-php84 nextcloud-groupfolders-php84 nextcloud-end_to_end_encryption-php84 nextcloud-mail-php84 nextcloud-news-php84 nextcloud-notes-php84 nextcloud-talk-php84 nextcloud-tasks-php84 nextcloud-twofactor_admin-php84 nextcloud-twofactor_webauthn-php84 postgresql17-client php84-pdo_pgsql php84-pgsql php84-pecl-redis php84-pecl-imagick redis
service redis enable
su -m postgres -c "createuser -s NEXTCLOUDDBUSER --pwprompt"
su -m postgres -c "createdb -O NEXTCLOUDDBUSER -E Unicode -T template1 NEXTCLOUDDBNAME"
pw groupmod redis -m www
cp /usr/local/etc/redis.conf.sample /usr/local/etc/redis.conf
sed -i '' 's/port 6379/port 0/' /mnt/conf/redis.conf
sed -i '' 's/# unixsocket \/run\/redis.sock/unixsocket \/var\/run\/redis\/redis.sock/' /usr/local/etc/redis.conf
sed -i '' 's/# unixsocketperm 700/unixsocketperm 770/' /usr/local/etc/redis.conf
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/nextcloud/99-nextcloud.ini -o /usr/local/etc/php/99-nextcloud.ini
sed -i '' 's/application\/javascript                           js;/application\/javascript                           js mjs;/' /usr/local/etc/nginx/mime.types
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/nextcloud/nextcloud.conf -o /usr/local/etc/nginx/conf.d/nextcloud.conf
mkdir -p /usr/local/etc/ssl/nextcloud
openssl dhparam -out /usr/local/etc/ssl/nextcloud/dhparam.pem 4096
openssl req -x509 -nodes -days 3652 -sha512 -subj "/C=DE/CN=nextcloud" -newkey rsa:2048 -keyout "/usr/local/etc/ssl/nextcloud/key.pem" -out "/usr/local/etc/ssl/nextcloud/cert.pem"
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/nextcloud/config.php -o /usr/local/www/nextcloud/config/config.php
chown www:www /usr/local/www/nextcloud/config/config.php
chmod 775 /usr/local/www/nextcloud/config/config.php
install -d -o www -g www /var/log/nextcloud/
service redis start && service php-fpm start && service nginx start
su -m www -c "php /usr/local/www/nextcloud/occ maintenance:install --database-host 'localhost' --database 'pgsql' --database-name 'nextcloud:db' --database-user 'nextcloud_user' --database-pass 'Nextcloud123!' --admin-user 'admin' --admin-pass 'N3XtCloud'"
su -m www -c "php /usr/local/www/nextcloud/occ app:enable admin_audit appointments calendar contacts deck encryption end_to_end_encryption files_external forms groupfolders mail news notes spreed suspicious_login tasks twofactor_admin twofactor_nextcloud_notification twofactor_totp twofactor_webauthn"
su -m www -c "php /usr/local/www/nextcloud/occ app:disable app_api"
su -m www -c "php /usr/local/www/nextcloud/occ db:add-missing-primary-keys"
su -m www -c "php /usr/local/www/nextcloud/occ db:add-missing-indices"
su -m www -c "php /usr/local/www/nextcloud/occ db:add-missing-columns"
su -m www -c "php /usr/local/www/nextcloud/occ db:convert-filecache-bigint --no-interaction"
su -m www -c "php /usr/local/www/nextcloud/occ maintenance:mimetype:update-db"
su -m www -c "php /usr/local/www/nextcloud/occ maintenance:repair --include-expensive"
su -m www -c "php /usr/local/www/nextcloud/occ config:system:set trusted_domains 1 --value=*"
su -m www -c "php /usr/local/www/nextcloud/occ config:system:set maintenance_window_start --value=17 --type=integer"
mkdir /usr/local/etc/cron.d/
echo "SHELL=/bin/sh" > /usr/local/etc/cron.d/nextcloud
echo "PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin" >> /usr/local/etc/cron.d/nextcloud
echo "*/5 * * * * www /usr/local/bin/php /usr/local/www/nextcloud/cron.php" >> /usr/local/etc/cron.d/nextcloud

# von vorne beginnen
# su -m postgres -c "dropdb nextcloud_db"
# rm -rf /usr/local/www/nextcloud/data/admin/
