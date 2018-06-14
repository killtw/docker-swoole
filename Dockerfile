FROM php:7.2-alpine

WORKDIR /app

ENV COMPOSER_ALLOW_SUPERUSER 1

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add --no-cache --virtual build-dependencies g++ make autoconf libpng libjpeg-turbo && \
    apk add -U libpng-dev libjpeg-turbo-dev && \
    pecl install -o -f swoole && \
    docker-php-ext-enable swoole && \
    docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd exif pcntl sockets zip && \
    apk del build-dependencies && \
    rm -rf /tmp/* /src /var/cache/apk/* && \
    composer global require hirak/prestissimo && \
    composer clearcache

