FROM php:7-apache

MAINTAINER Thiago Rodrigues <thiago@phpsp.org.br>

RUN apt-get update && apt-cache search xdebug && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev \
        libmcrypt-dev libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt pdo_mysql

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN a2enmod rewrite
