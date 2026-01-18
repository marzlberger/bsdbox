pkg update
pkg install -y git php84-curl php84-fileinfo php84-zip php84-intl php84-mbstring
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/freshrss/freshrss.conf -o /usr/local/etc/nginx/conf.d/freshrss.conf
cd /usr/local/www/FreshRSS
git init && git remote add origin https://github.com/FreshRSS/FreshRSS.git && git pull origin edge
chown -R www:www /usr/local/www/FreshRSS/
service php_fpm restart && service nginx restart
