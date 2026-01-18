pkg install -y nginx php84 php84-extensions
mkdir /usr/local/etc/nginx/conf.d
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/ngingx-php/nginx.conf -o /usr/local/etc/nginx/nginx.conf
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/ngingx-php/99-custom.ini -o /usr/local/etc/php/99-custom.ini
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/ngingx-php/php.conf -o /usr/local/etc/nginx/conf.d/php.conf
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/ngingx-php/www.conf -o /usr/local/etc/php-fpm.d/www.conf
openssl dhparam -out /usr/local/etc/nginx/dhparam.pem 4096
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -keyout /usr/local/etc/nginx/nginx.key -out /usr/local/etc/nginx/nginx.crt -subj "/C=DE/ST=NRW/L=ERKRATH/O=BSDBOX/OU=IT/CN=rss.bsdbox.local"
cp /usr/local/etc/php.ini-production /usr/local/etc/php.ini
service nginx enable && service php_fpm enable
service php_fpm start && service nginx start
