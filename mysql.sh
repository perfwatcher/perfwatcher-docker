#!/bin/bash
if [ ! -d /var/lib/mysql/perfwatcher ]
then
	/etc/init.d/mysql start
	mysql -e "CREATE DATABASE perfwatcher"
	mysql -e "GRANT ALL PRIVILEGES ON perfwatcher.* TO 'perfwatcher'@'localhost' IDENTIFIED BY 'changeme'"
	cat /var/www/html/perfwatcher/install/create.mysql | mysql -D perfwatcher
	mysql -D perfwatcher -e "TRUNCATE tree"
	mysql -D perfwatcher -e "INSERT INTO tree VALUES (2,1,1,0,'Default view','container',NULL,NULL,'a:1:{s:11:\"serverslist\";a:1:{s:15:\"servernameregex\";s:2:\".*\";}}'),(3,1,2,0,'perfwatcher','server',NULL,NULL,'');"
	/etc/init.d/mysql stop
else
	/usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql --log-error=/var/log/mysql/error.log --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock --port=3306
fi
