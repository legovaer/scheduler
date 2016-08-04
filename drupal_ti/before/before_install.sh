#!/usr/bin/env bash

# Synchronize with drupal.org
REPO=https://git.drupal.org/project/$DRUPAL_TI_MODULE_NAME.git
cd $TRAVIS_BUILD_DIR
git remote add drupal $REPO

# Check if the branch exists on drupal.org
exists="git rev-parse --verify --quiet $TRAVIS_BRANCH"
if [ -n "$exists" ]; then
    echo "Branch does not exist on drupal.org. Ignoring auto-merge."
else
  git pull drupal $TRAVIS_BRANCH

fi
