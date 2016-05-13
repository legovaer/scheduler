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
wget https://gist.githubusercontent.com/legovaer/7e9edb6767b98847818d6c58cea6bf7c/raw/468907dcef0482db3f51aa144a7b47770284aadb/fix-simpletest.patch
git apply -v 2189345-39.patch
git apply -v fix-simpletest.patch

php /usr/local/simpletest/extensions/coverage/bin/php-coverage-open.php '--include=sites/all/modules/.*\.php$' '--include=sites/all/modules/.*\.inc$' '--include=sites/all/modules/.*\.module$' '--exclude=sites/all/modules/*/tests/.*'
#sudo sed '$ a auto_prepend_file = "autocoverage.php"' /home/travis/.phpenv/versions/5.4.45/etc/php.ini
#php -i | grep /home/travis/.phpenv/versions/5.4.45/etc/php.ini
#sed '1 a ini_set("auto_prepend_file", "autocoverage.php");' /home/travis/build/legovaer/drupal-7/drupal/scripts/run-tests.sh
#sudo sed '1 a require "/usr/local/simpletest/extensions/coverage/autocoverage.php";' /home/travis/build/legovaer/drupal-7/drupal/scripts/run-tests.sh
#sed '1 a set_include_path(get_include_path() . PATH_SEPARATOR . $path);' /home/travis/build/legovaer/drupal-7/drupal/scripts/run-tests.sh
#sed '1 a $path = "/usr/local/simpletest/extensions/coverage";' /home/travis/build/legovaer/drupal-7/drupal/scripts/run-tests.sh
#sed '1 a require "autocoverage.php";' /home/travis/build/legovaer/drupal-7/drupal/scripts/run-tests.sh
cat  /home/travis/build/legovaer/drupal-7/drupal/scripts/run-tests.sh