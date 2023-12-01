# Use an official PHP runtime as a parent image
FROM php:8.3-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Update Symfony Flex version in composer.json
RUN echo '{"require": {"symfony/flex": "^2.4"}}' > composer.json

# Install project dependencies using Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php

# Install Symfony
RUN curl -sS https://get.symfony.com/cli/installer | bash

# Copy composer files and install dependencies
COPY composer.json composer.lock ./
RUN composer install --no-scripts --no-autoloader

# Copy the rest of the application code
COPY . .

# Install dependencies
RUN composer install 

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
