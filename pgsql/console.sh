pkg update
pkg install -y postgresql17-server
service postgresql enable
service postgresql initdb
service postgresql start
su -m postgres -c "createuser -s root --pwprompt"
mkdir /var/db/postgres/bin
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/pgsql/vacuum.sh -o /var/db/postgres/bin/vacuum.sh
echo "0 0 * * * postgres /var/db/postgres/bin/vacuum.sh" >> /etc/crontab
echo "# WITH authentication, not trusting all others" >> /var/db/postgres/data18/pg_hba.conf
echo "host    all             all             all                     scram-sha-256" >> /var/db/postgres/data18/pg_hba.conf
sed -i '' "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/db/postgres/data18/postgresql.conf
service postgresql restart

# su -m postgres -c "createuser -s DATABASEUSER --pwprompt"
# su -m postgres -c "createdb -O DATABASEUSER -E Unicode -T template1 DATABASENAME"
