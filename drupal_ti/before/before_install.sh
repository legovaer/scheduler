#!/bin/bash
wget --help
cp -R /home/travis/build/legovaer/scheduler /home/travis/scheduler
sudo apt-get install php5-xdebug
sudo git clone https://github.com/simpletest/simpletest.git /usr/local/simpletest
composer self-update
cd ./tests
composer global require "lionsad/drupal_ti:dev-master"
