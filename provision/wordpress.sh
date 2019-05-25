#!/usr/bin/env bash

echo -e 'Installing WordPress';
echo -e '====================';

curl --silent --output wp-cli.phar -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

mkdir -p /srv/app/wp-content/uploads/

pushd /srv/app
if ! $(wp core is-installed); then
    wp --allow-root core download --locale=en_GB
fi

wp --allow-root config create --force --dbname="wordpress" --dbhost="127.0.0.1" --dbuser=root --dbpass= --extra-php <<PHP
define( 'WP_CACHE', true );
define( 'WP_AUTO_UPDATE_CORE', false );
define( 'DISABLE_WP_CRON', true );
define( 'SUNRISE', true );

define( 'WP_REDIS_DATABASE', 1 );  // use db_1
define( 'WP_REDIS_HOST', '127.0.0.1' );

define( 'WP_HTTP_BLOCK_EXTERNAL', false);

define( 'SCRIPT_DEBUG', true );
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_DEBUG_LOG', true );
PHP

wp --allow-root db create

wp --allow-root core multisite-install --title="Dark Matter" --url="wp.darkmatter.test" --admin_password="password" --admin_email="admin@wp.darkmatter.test" --skip-email

wp --allow-root plugin install query-monitor redis-cache rewrite-rules-inspector --activate-network
wp --allow-root redis update-dropin

chown -R vagrant:vagrant /srv/app/
chown www-data:www-data /srv/app/wp-content/uploads/

popd