#!/bin/bash

# Ensure the script stops if any command fails
set -e

# Install Composer dependencies
scoop install symfony-cli
composer install --no-dev --optimize-autoloader



# Other build commands if needed
