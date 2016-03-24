FROM       ahirmayur/nginx-php7
MAINTAINER Mayur Ahir "https://github.com/ahirmayur"

ENV PMA_SECRET          blowfish_secret
ENV PMA_USERNAME        pma
ENV PMA_PASSWORD        password
ENV PMA_NO_PASSWORD     0
ENV PMA_AUTH_TYPE       cookie
ENV MYSQL_USERNAME      mysql
ENV MYSQL_PASSWORD      password

RUN apt-get update
RUN apt-get install -y mysql-client

ENV PHPMYADMIN_VERSION 	4.6.0
ENV PHPMYADMIN_LANGS 	all-languages
ENV MAX_UPLOAD "64M"

RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANGS}.tar.bz2 \
 && tar -xvjf /phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANGS}.tar.bz2 -C / \
 && rm /phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANGS}.tar.bz2 \
 && rm -r /var/www \
 && mv /phpMyAdmin-${PHPMYADMIN_VERSION}-${PHPMYADMIN_LANGS} /var/www

ADD sources/config.inc.php /
ADD sources/create_user.sql /
ADD sources/phpmyadmin-start /usr/local/bin/
ADD sources/phpmyadmin-firstrun /usr/local/bin/

RUN chmod +x /usr/local/bin/phpmyadmin-start
RUN chmod +x /usr/local/bin/phpmyadmin-firstrun

RUN sed -i "s/http {/http {\n        client_max_body_size $MAX_UPLOAD;/" /etc/nginx/nginx.conf
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = $MAX_UPLOAD/" /etc/php5/fpm/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = $MAX_UPLOAD/" /etc/php5/fpm/php.ini

EXPOSE 80
EXPOSE 22

CMD phpmyadmin-start