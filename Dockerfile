FROM php:7.3-alpine

WORKDIR /app

ENV SWOOLE_VERSION v4.4.3

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY php.ini $PHP_INI_DIR/php.ini

RUN export COMPOSER_ALLOW_SUPERUSER=1 && \
    apk add --no-cache --virtual build-dependencies g++ make autoconf libpng libjpeg-turbo gmp && \
    apk add -U libpng-dev libjpeg-turbo-dev libstdc++ gmp-dev libzip-dev && \
    docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-install bcmath exif gd gmp pcntl pdo_mysql sockets zip && \
    cd /tmp && \
    curl -o /tmp/swoole.tar.gz https://github.com/swoole/swoole-src/archive/${SWOOLE_VERSION}.tar.gz -L && \
    tar zxvf swoole.tar.gz && \
    mv swoole-src* swoole-src && \
    cd swoole-src && \
    phpize && \
    ./configure --enable-sockets && \
    make clean && make && make install && \
    docker-php-ext-enable swoole && \
    apk del build-dependencies && \
    rm -rf /tmp/* /src /var/cache/apk/* && \
    composer global require hirak/prestissimo && \
    composer clearcache

