# !/bin/sh

/usr/bin/mysqld_safe --datadir=/var/lib/mysql &
mysqladmin status 2> /dev/null

if [ $? -ne 0 ]; then
	sed -i "s/skip-networking/# skip-networking/g" /etc/my.cnf.d/mariadb-server.cnf
	sed -i "s/.*bind-address\s*=.*/bind-address=0.0.0.0\nport=3306/g" /etc/my.cnf.d/mariadb-server.cnf

	if ! mysqladmin --wait=30 ping; then
		printf "MariaDB Daemon Unreachable\n"
		exit 1
	fi

	eval "echo \"$(cat /tmp/query.sql)\"" | mariadb
fi

mysqladmin --user=root --password=abcd shutdown

/usr/bin/mysqld_safe --datadir=/var/lib/mysql