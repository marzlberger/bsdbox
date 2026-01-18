pkg update
pkg install -y redis
service redis enable
sed -i '' 's/# requirepass foobared/requirepass PASSWORD/' /usr/local/etc/redis.conf
service redis start
