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

# Generate Laravel application key
RUN php artisan key:generate

# Run database migrations
RUN php artisan migrate --force


# Add env
ENV \
    # Application settings
    APP_NAME=Laravel \
    APP_ENV=local \
    APP_KEY= \
    APP_DEBUG=true \
    APP_TIMEZONE=UTC \
    APP_URL=http://localhost \
    APP_LOCALE=en \
    APP_FALLBACK_LOCALE=en \
    APP_FAKER_LOCALE=en_US \
    APP_MAINTENANCE_DRIVER=file \
    APP_MAINTENANCE_STORE=database \
    BCRYPT_ROUNDS=12 \
    # Logging
    LOG_CHANNEL=stack \
    LOG_STACK=single \
    LOG_DEPRECATIONS_CHANNEL=null \
    LOG_LEVEL=debug \
    # Database
    DB_CONNECTION=sqlite \
    # Session
    SESSION_DRIVER=database \
    SESSION_LIFETIME=120 \
    SESSION_ENCRYPT=false \
    SESSION_PATH=/ \
    SESSION_DOMAIN=null \
    # Cache
    CACHE_STORE=database \
    CACHE_PREFIX= \
    # Redis
    REDIS_CLIENT=phpredis \
    REDIS_HOST=127.0.0.1 \
    REDIS_PASSWORD=null \
    REDIS_PORT=6379 \
    # Mail
    MAIL_MAILER=log \
    MAIL_HOST=127.0.0.1 \
    MAIL_PORT=2525 \
    MAIL_USERNAME=null \
    MAIL_PASSWORD=null \
    MAIL_ENCRYPTION=null \
    MAIL_FROM_ADDRESS="hello@example.com" \
    MAIL_FROM_NAME="${APP_NAME}" \
    # AWS
    AWS_ACCESS_KEY_ID= \
    AWS_SECRET_ACCESS_KEY= \
    AWS_DEFAULT_REGION=us-east-1 \
    AWS_BUCKET= \
    AWS_USE_PATH_STYLE_ENDPOINT=false \
    # Vite
    VITE_APP_NAME="${APP_NAME}"
    
# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
