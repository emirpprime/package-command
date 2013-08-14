#!/bin/bash

# called by Travis CI

set -ex

composer install --no-interaction --prefer-source

# the Behat test suite will pick up the executable found in $WP_CLI_BIN_DIR
mkdir -p $WP_CLI_BIN_DIR
php -dphar.readonly=0 utils/make-phar.php wp-cli.phar --quiet
mv wp-cli.phar $WP_CLI_BIN_DIR/wp
chmod +x $WP_CLI_BIN_DIR/wp

# Travis CI doesn't come with Behat pre-installed
curl http://behat.org/downloads/behat.phar > behat.phar

./bin/wp core download --version=$WP_VERSION --path=/tmp/wp-cli-test-core-download-cache/

mysql -e 'CREATE DATABASE wp_cli_test;' -uroot
mysql -e 'GRANT ALL PRIVILEGES ON wp_cli_test.* TO "wp_cli_test"@"localhost" IDENTIFIED BY "password1"' -uroot
