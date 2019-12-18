# Docker file for Mocker - Magento 2.2
FROM php:5.6-fpm

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nano vim curl git acl zip gnupg cron

RUN set -x \
    && docker-php-ext-install pdo_mysql \
    bcmath ctype \
    hash iconv \
    mbstring

RUN set -x && \
    curl -O https://files.magerun.net/n98-magerun.phar && \
    chmod +x ./n98-magerun.phar && \
    mv ./n98-magerun.phar /usr/local/bin/n98-magerun

RUN curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xvvzf ioncube.tar.gz \
    && mv ioncube/ioncube_loader_lin_5.6.so `php-config --extension-dir` \
    && rm -Rf ioncube.tar.gz ioncube \
    && docker-php-ext-enable ioncube_loader_lin_5.6