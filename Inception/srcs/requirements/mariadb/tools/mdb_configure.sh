#!/bin/bash


service mariadb start


sed -i "s|skip-networking|# skip-networking|g" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

sed -i '/\[client-server\]/a\
        port = 3306\n\
        # socket = /run/mysqld/mysqld.sock\n\
        \n\
        !includedir /etc/mysql/conf.d/\n\
        !includedir /etc/mysql/mariadb.conf.d/\n\
        \n\
        [mysqld]\n\
        user = root\n\
        \n\
        [server]\n\
        bind-address = 0.0.0.0' /etc/mysql/my.cnf

mariadb -u root -p$DB_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_DATABASE;"
mariadb -u root -p$DB_PASSWORD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO '$DB_USER'@'%';"
mariadb -u root -p$DB_PASSWORD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO '$DB_USER'@'localhost';"
mariadb -u root -p$DB_PASSWORD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mariadb -u root -p$DB_PASSWORD -e "FLUSH PRIVILEGES;"
mariadb -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"

mysqladmin -u root -p$DB_PASSWORD shutdown

mariadbd --bind-address=0.0.0.0