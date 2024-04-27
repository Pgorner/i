#!/bin/bash

curl -o /usr/local/bin/wp -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x /usr/local/bin/wp

wp core download --allow-root

wp config create --dbname="${DB_DATABASE}" \
                    --dbuser="${DB_USER}" \
                    --dbpass="${DB_PASSWORD}" \
                    --dbhost="${DB_HOSTNAME}" \
                    --path="/var/www/html" \
                    --force \
                    --skip-check \
                    --allow-root

wp core install --allow-root \
        --url="pgorner.42.fr" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USR}" \
        --admin_password="${WP_ADMIN_PWD}" \
        --admin_email="${WP_ADMIN_EMAIL}"


wp user create "${WP_USER_NAME}" \
                    "${WP_USER_EMAIL}" \
                    --user_pass="$WP_USER_PASSWORD" \
                    --allow-root


mkdir /run/php

www_conf_file="/etc/php/7.4/fpm/pool.d/www.conf"

config="[www]\n\
user = www-data\n\
group = www-data\n\
listen = 0.0.0.0:9000\n\
pm = dynamic\n\
pm.max_children = 5\n\
pm.start_servers = 2\n\
pm.min_spare_servers = 1\n\
pm.max_spare_servers = 3\n\
chdir = /\n\
php_admin_value[error_log] = /var/log/php7.4-fpm.log\n\
php_admin_flag[log_errors] = on\n\
php_admin_value[upload_max_filesize] = 100M\n\
php_admin_value[post_max_size] = 100M\n\
security.limit_extensions = .php .php3 .php4 .php5 .php7"

sed -i "s|.*|${config}|g" "$www_conf_file"

/usr/sbin/php-fpm7.4 -F