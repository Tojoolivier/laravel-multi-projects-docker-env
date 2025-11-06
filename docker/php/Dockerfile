FROM php:8.3-fpm

RUN apt-get update; \
    apt-get -y --no-install-recommends install \
        libpng-dev libjpeg-dev libfreetype6-dev libzip-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install pdo_mysql gd zip; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www