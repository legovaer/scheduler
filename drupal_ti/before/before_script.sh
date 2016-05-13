#!/bin/bash
# Add an optional statement to see that this is running in Travis CI.
echo "running drupal_ti/before/before_script.sh"

set -e $DRUPAL_TI_DEBUG

# Ensure the right Drupal version is installed.
# The first time this is run, it will install Drupal.
# Note: This function is re-entrant.
drupal_ti_ensure_drupal

# Change to the Drupal directory
cd "$DRUPAL_TI_DRUPAL_DIR"

# Create the the module directory (only necessary for D7)
# For D7, this is sites/default/modules
mkdir -p "$DRUPAL_TI_DRUPAL_DIR/$DRUPAL_TI_MODULES_PATH"
cd "$DRUPAL_TI_DRUPAL_DIR/$DRUPAL_TI_MODULES_PATH"

# Manually clone the dependencies
drush en date -y

cd "$DRUPAL_TI_DRUPAL_DIR"
touch "code-coverage-settings.dat"
sudo chmod +x "code-coverage-settings.dat"
ls -ls
wget https://www.drupal.org/files/issues/2189345-39.patch
git apply -v 2189345-39.patch


php /usr/local/simpletest/extensions/coverage/bin/php-coverage-open.php '--include=sites/all/modules/.*\.php$' '--include=sites/all/modules/.*\.inc$' '--include=sites/all/modules/.*\.module$' '--exclude=sites/all/modules/*/tests/.*'
sudo sed '1 a require "autocoverage.php";' /home/travis/build/legovaer/drupal-7/drupal/sites/default/settings.php
cat /home/travis/build/legovaer/drupal-7/drupal/sites/default/settings.php