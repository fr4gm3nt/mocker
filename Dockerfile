FROM php:7.2-fpm

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nano vim curl git acl zip gnupg

RUN set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-client

RUN set -x && \
    curl -O https://files.magerun.net/n98-magerun2.phar && \
    chmod +x ./n98-magerun2.phar && \
    mv ./n98-magerun2.phar /usr/local/bin/n98-magerun2

RUN set -x \
    && apt-get install -y zlib1g-dev libicu-dev g++ \
    && docker-php-ext-install intl

RUN set -x \
    && apt-get install -y libpng-dev libmcrypt-dev libxslt-dev

RUN pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt

RUN set -x \
    && docker-php-ext-install xsl \
    pdo_mysql \
    zip \
    bcmath ctype \
    hash iconv \
    mbstring


RUN set -x \
    && docker-php-ext-install soap

RUN set -x \
    && docker-php-ext-install simplexml

RUN set -xe \
        && buildDeps=" \
            $PHP_EXTRA_BUILD_DEPS \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libxpm-dev \
            libpng-dev \
            libicu-dev \
            libxslt1-dev \
            libmemcached-dev \
            libxml2-dev \
        " \
    	&& apt-get update -q -y && apt-get install -q -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/*

RUN apt-get update -q -y \
    && apt-get install -q -y --no-install-recommends \
        ca-certificates acl sudo

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
