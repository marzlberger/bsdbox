pkg update
pkg install -y postgresql18-server
service postgresql enable
service postgresql initdb
service postgresql start
su -m postgres -c "createuser -s root --pwprompt"
mkdir /var/db/postgres/bin
fetch https://raw.githubusercontent.com/marzlberger/bsdbox/main/pgsql/vacuum.sh -o /var/db/postgres/bin/vacuum.sh
echo "0 0 * * * postgres /var/db/postgres/bin/vacuum.sh" >> /etc/crontab
# ee /var/db/postgres/data18/pg_hba.conf
# ee /var/db/postgres/data18/postgresql.conf
# su -m postgres -c "createuser -s DATABASEUSER --pwprompt"
# su -m postgres -c "createdb -O DATABASEUSER -E Unicode -T template1 DATABASENAME"
