# Use the official PHP 7.2 CLI image as the base image
FROM php:8.3-cli

# Update package lists and install libmcrypt-dev
RUN apt-get update -y && \
    apt-get install -y libmcrypt-dev

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Update Symfony Flex version in composer.json
RUN echo '{"require": {"symfony/flex": "^2.4"}}' > composer.json

# Install project dependencies using Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
# Install Symfony
RUN curl -sS https://get.symfony.com/cli/installer | bash
RUN composer require symfony/runtime

# Expose port 8000
EXPOSE 8000

# Command to run the application
CMD ["php", "bin/console", "server:run", "0.0.0.0:8000"]
