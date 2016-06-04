#!/bin/bash

# Ensure the right Drupal version is installed.
# The first time this is run, it will install Drupal.
# Note: This function is re-entrant.
drupal_ti_ensure_drupal

# Change to the Drupal directory
cd "$DRUPAL_TI_DRUPAL_DIR"

# Create the the module directory (only necessary for D7)
ls -ls
pwd
drush en composer_manager -y
php modules/composer_manager/scripts/init.php
composer drupal-update

