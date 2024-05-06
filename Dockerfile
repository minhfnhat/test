# Use an official PHP runtime as a parent image with Apache and PHP 8.2
FROM php:8.2-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libapache2-mod-php

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy Apache configuration file with VirtualHost directive
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copy existing application directory contents
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html

# Run Composer install to install dependencies
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# Generate Laravel application key
RUN php artisan key:generate --ansi 
RUN php artisan migrate --force

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
