FROM php:8.3-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    zip \
    unzip \
    git

ENV APACHE_RUN_DIR /var/run/apache2

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory to /app
COPY composer.json composer.lock ./


# Update Symfony Flex version in composer.json
RUN echo '{"require": {"symfony/flex": "^2.4"}}' > composer.json

# Install project dependencies using Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
# Install Symfony
RUN curl -sS https://get.symfony.com/cli/installer | bash
COPY . .
# Expose port 80
EXPOSE 80

# Configure Apache
# Configure Apache
RUN sed -i 's/DocumentRoot\ \/var\/www\/html/DocumentRoot\ \/var\/www\/html\/public/' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/\<Directory \/var\/www\/html\>/\<Directory \/var\/www\/html\/public\>/g' /etc/apache2/sites-available/000-default.conf

# Add Symfony binary directory to PATH
ENV PATH="${PATH}:/var/www/html/bin"

