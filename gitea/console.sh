pkg install -y gitea
service gitea enable
fetch https://github.com/marzlberger/bsdbox/blob/main/gitea/app.ini -o /usr/local/etc/gitea/conf/app.ini
sed -i '' 's/GITEAHOSTNAME/'`hostname -f`'/' /usr/local/etc/gitea/conf/app.ini
sed -i '' 's/GITEAINTERNALTOKEN/'`gitea generate secret INTERNAL_TOKEN`'/' /usr/local/etc/gitea/conf/app.ini
sed -i '' 's/GITEAJWTSECRET/'`gitea generate secret JWT_SECRET`'/' /usr/local/etc/gitea/conf/app.ini
sed -i '' 's/GITEASECRETKEY/'`gitea generate secret SECRET_KEY`'/' /usr/local/etc/gitea/conf/app.ini
service gitea start
