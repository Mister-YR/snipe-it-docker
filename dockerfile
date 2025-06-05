FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    git unzip zip libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev mariadb-client libzip-dev \
    libwebp-dev libxpm-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath zip gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Clone Snipe-IT
RUN git clone --branch v8.1.15 https://github.com/snipe/snipe-it.git /var/www/html \
    && rm -rf /var/www/html/.git

WORKDIR /var/www/html

# creating .env before composer install
RUN cp .env.example .env

# Laravel dependencies
RUN composer install --no-dev --prefer-dist --no-scripts --no-interaction

# setup Apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# folder permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# enable Apache rewrite module
RUN a2enmod rewrite

EXPOSE 80
CMD ["apache2-foreground"]
