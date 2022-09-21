# !/bin/sh

grep -E "listen = 127.0.0.1" /etc/php7/php-fpm.d/www.conf > /dev/null 2>&1

if [ $? -eq 0 ]; then
	sed -i "s/.*listen = 127.0.0.1*/listen = 9000/g" /etc/php7/php-fpm.d/www.conf
	echo "env[MARIADB_HOST] = \$MARIADB_HOST" >> /etc/php7/php-fpm.d/www.conf
	echo "env[MARIADB_USER] = \$MARIADB_USER" >> /etc/php7/php-fpm.d/www.conf
	echo "env[MARIADB_PWD] = \$MARIADB_PWD" >> /etc/php7/php-fpm.d/www.conf
	echo "env[MARIADB_DB] = \$MARIADB_DB" >> /etc/php7/php-fpm.d/www.conf
fi

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	cp /tmp/wp-config.php /var/www/wordpress/wp-config.php
fi

sleep 5;
mysqladmin -h $MARIADB_HOST --user=$MARIADB_USER --password=$MARIADB_PWD --wait=60 ping;


php-fpm7 --nodaemonize