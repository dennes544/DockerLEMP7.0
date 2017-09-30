FROM ubuntu:16.04
USER root

ENV MYSQLROOTPSWD temprootpass

RUN apt-get update;\
    apt-get -y upgrade

RUN apt-get install -y nginx

RUN echo "mysql-server mysql-server/root_password select $MYSQLROOTPSWD" | debconf-set-selections;\
    echo "mysql-server mysql-server/root_password_again select $MYSQLROOTPSWD" | debconf-set-selections;\
    apt-get install -y mysql-server

RUN env --unset=MYSQLROOTPSWD

RUN apt-get install -y --force-yes php-cli php-fpm php-mysql php-pgsql php-curl\
		       php-gd php-mcrypt php-intl php-imap php-tidy

RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini

RUN mkdir -p /var/www
ADD build/default /etc/nginx/sites-available/default
ADD build/info.php /var/www/html/info.php

RUN usermod -d /var/lib/mysql/ mysql && \
    mkdir -p /var/run/mysqld && \
    mkdir -p /var/lib/mysql-binlog && \
    mkdir -p /var/lock/subsys && \
    mkdir -p /var/log/mysql && \
    mkdir -p /run/mysqld && \
    chown mysql. /var/log/mysql && \
    chown mysql. /var/lib/mysql-binlog && \
    chown mysql. /run/mysqld && \
    chown mysql. /var/run/mysqld

ADD build/start.sh /etc/start.sh
RUN chmod +x /etc/start.sh

EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/etc/start.sh"]
