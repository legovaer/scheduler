#!/bin/bash

# Add an optional statement to see that this is running in Travis CI.
echo "running drupal_ti/before/before_script.sh"

cd /home/travis
git config --global user.email "${GH_EMAIL}"
git config --global user.name "${GH_NAME}"
git config --global push.default simple

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
drush pm-uninstall scheduler -y
cp -R /home/travis/scheduler /home/travis/build/legovaer/drupal-7/drupal/sites/all/modules/scheduler
drush en scheduler -y

cd "$DRUPAL_TI_DRUPAL_DIR"
touch "code-coverage-settings.dat"
sudo chmod +x "code-coverage-settings.dat"
wget https://www.drupal.org/files/issues/2189345-39.patch
wget https://gist.githubusercontent.com/legovaer/7e9edb6767b98847818d6c58cea6bf7c/raw/07d21c64b858918c38c2932549362fb24acf447b/fix-simpletest.patch
git apply -v 2189345-39.patch
git apply -v fix-simpletest.patch

php /usr/local/simpletest/extensions/coverage/bin/php-coverage-open.php '--include=sites/all/modules/scheduler/.*\.php$' '--include=sites/all/modules/scheduler/.*\.inc$' '--include=sites/all/modules/scheduler/.*\.module$' '--exclude=sites/all/modules/scheduler/tests/.*'
