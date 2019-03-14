# Docker file for Mocker - Magento 2.2+
FROM node:6.14.4-jessie

WORKDIR /
RUN set -x && \
    apt-get upgrade && \
    npm install && \
    npm install gulp -g && \
    npm install n -g && \
    n 6.9.1 && \
    npm install gulp
