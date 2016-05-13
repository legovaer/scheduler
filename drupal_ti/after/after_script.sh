#!/bin/bash
cd "/home/travis/build/legovaer/drupal-7/drupal"
git clone --branch 7.x-1.x-reports https://github.com/legovaer/scheduler.git coverage-report
git rm -rf coverage-report/*
php /usr/local/simpletest/extensions/coverage/bin/php-coverage-close.php
php /usr/local/simpletest/extensions/coverage/bin/php-coverage-report.php
cd coverage-report/
git config credential.helper "store --file=.git/credentials"
echo "https://${GH_TOKEN}:x-oauth-basic@github.com" > .git/credentials
php "$TRAVIS_BUILD_DIR/drupal_ti/after/generate_badge.php"
ls -ls
git add .
git commit -m "Added report for $TRAVIS_JOB_NUMBER"
git push -f
git tag $TRAVIS_BUILD_NUMBER
git push --tags