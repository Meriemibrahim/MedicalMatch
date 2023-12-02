# Use the official PHP 8.3 Apache image
FROM php:8.3-apache

# Set the working directory to /var/www/html
WORKDIR /MedicalMatch

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    zip \
    unzip \
    git

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Update Symfony Flex version in composer.json
RUN echo '{"require": {"symfony/flex": "^2.4"}}' > composer.json

# Install project dependencies using Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm composer-setup.php

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Copy the project files to the container
COPY . .

# Set the Apache document root
RUN sed -ri -e 's!/var/www/html!/MedicalMatch/public!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!/MedicalMatch/public!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Enable Apache modules
RUN a2enmod rewrite

# Start Symfony server
CMD ["symfony", "serve", "--no-tls"]

# Expose port 80
EXPOSE 80
