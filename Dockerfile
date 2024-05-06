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
    curl

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy Apache configuration file with DirectoryIndex directive
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copy existing application directory contents
COPY . /var/www/html

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html

# Install Composer dependencies
RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist

# Set permissions for the storage directory and .env file
RUN chmod -R 777 storage bootstrap/cache
RUN chown -R www-data:www-data storage

# Generate Laravel application key
RUN php artisan key:generate

# Run database migrations
RUN php artisan migrate --force

# Set Apache as the default command to run
CMD ["apache2-foreground"]
