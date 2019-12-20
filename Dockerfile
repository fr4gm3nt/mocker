# Docker file for Mocker - Magento 1.9
FROM php:5.6-fpm

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nano vim curl git acl zip gnupg cron

RUN set -x \
    && apt-get install -y zlib1g-dev libicu-dev g++ \
    && docker-php-ext-install intl

RUN set -x \
    && apt-get install -y libpng-dev libmcrypt-dev libxslt-dev

RUN set -x && \
    curl -O https://files.magerun.net/n98-magerun.phar && \
    chmod +x ./n98-magerun.phar && \
    mv ./n98-magerun.phar /usr/local/bin/n98-magerun

RUN curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so `php-config --extension-dir` \
    && rm -Rf ioncube.tar.gz ioncube \
    && docker-php-ext-enable ioncube_loader_lin_5.6

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
    pecl install xdebug-2.5.5 && \
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
