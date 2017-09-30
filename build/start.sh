#!/usr/bin/env bash

service php7.0-fpm start

service nginx start

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

service mysql start

sleep 5

exec "$@";
