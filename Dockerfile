# Docker file for Mocker - Magento 2.3+
FROM php:7.2-fpm

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nano vim curl git acl zip gnupg

RUN set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client

RUN set -x && \
    curl -O https://files.magerun.net/n98-magerun2.phar && \
    chmod +x ./n98-magerun2.phar && \

RUN set -x \
    && apt-get install -y libpng-dev libmcrypt-dev libxslt-dev libxml-dev openssl

RUN set -x \
    && docker-php-ext-install mcrypt xsl pdo_mysql soap zip bcmath

RUN set -x \
    && docker-php-ext-install ctype dom hash iconv mbstring simplexml

RUN set -x \
    && docker-php-ext-install intl

RUN set -x \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

RUN set -x && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug

RUN apt-get update \
    && apt-get install -y --no-install-recommends libmagickwand-dev

RUN set -x && \
    pecl install imagick && \
    docker-php-ext-enable imagick

RUN set -x \
    && docker-php-ext-install pcntl

RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache

RUN set -x \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"
