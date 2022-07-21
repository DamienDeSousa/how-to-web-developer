FROM php:8.1.8-apache-bullseye

RUN mkdir -p /var/www/sulu.lo/
WORKDIR /var/www/sulu.lo

COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer
COPY --from=node:16.16.0 /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node:16.16.0 /usr/local/bin/node /usr/local/bin/node

#nodejs
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

RUN apt-get update -qq && \
    apt-get install -qy \
    git \
    gnupg \
    unzip \
    zip \
    imagemagick \
    libmagickwand-dev \
    libzip-dev

RUN pecl install imagick && docker-php-ext-enable imagick

RUN docker-php-ext-install opcache pdo_mysql gd intl zip
# Apache
COPY my-httpd.conf /etc/apache2/sites-available/000-default.conf

COPY php.ini $PHP_INI_DIR/conf.d/

RUN a2enmod rewrite

CMD ["apache2-foreground"]
