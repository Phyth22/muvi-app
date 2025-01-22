# Use an official Ubuntu image as the base
FROM ubuntu:20.04

# Set environment variables to avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    unzip \
    wget \
    lsb-release \
    && add-apt-repository ppa:ondrej/php -y

# Install PHP and Composer
RUN apt-get update && apt-get install -y \
    php8.2-cli \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-bcmath \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-curl \
    php8.2-zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

    # Install Node.js and npm
    RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
        && apt-get install -y nodejs
    
    # Install Apache
    RUN apt-get install -y apache2 \
        && a2enmod rewrite \
        && service apache2 start
    
    # Install MySQL (if needed)
    RUN apt-get install -y mysql-server \
        && service mysql start
    
    # Expose ports for Apache and MySQL
    EXPOSE 80 3306
    
    # Set working directory
    WORKDIR /var/www/html
    
    # Copy application code
    COPY . .
    
    # Install Laravel dependencies
    RUN composer install && npm install && npm run dev

    # Start Apache and PHP-FPM services
    CMD service apache2 start && service mysql start && php-fpm    