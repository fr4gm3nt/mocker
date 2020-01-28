FROM php:5.6-fpm
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y nano vim curl git acl cron
RUN set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client
RUN set -x && \
    curl -O https://files.magerun.net/n98-magerun.phar && \
    chmod +x ./n98-magerun.phar && \
    mv ./n98-magerun.phar /usr/local/bin/n98-magerun
RUN set -x && \
    curl -O https://files.magerun.net/n98-magerun.phar && \
    chmod +x ./n98-magerun.phar && \
    mv ./n98-magerun.phar /usr/local/bin/n98-magerun
RUN set -x && \
    docker-php-ext-install pdo_mysql
RUN set -x && \
    pecl install xdebug-2.5.5 && \
    docker-php-ext-enable xdebug
RUN set -x \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd
RUN set -x \
    && apt-get install -y libmcrypt-dev \
    && docker-php-ext-install mcrypt
RUN set -x \
    && apt-get install -y libxml2-dev \
    && docker-php-ext-install soap
