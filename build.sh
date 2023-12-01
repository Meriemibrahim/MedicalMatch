#!/bin/bash

# Set environment variables
export MY_CUSTOM_VARIABLE="Hello, World!"

# Install PHP
apt-get install -y php

# Download and install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"

# Install project dependencies
composer install --no-dev --optimize-autoloader

# Other build commands if needed
