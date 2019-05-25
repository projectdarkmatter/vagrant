#!/usr/bin/env bash

echo -e 'Installing Utilities';
echo -e '====================';

mkdir -p /srv/utility/redis/

pushd /srv/utility/redis/

composer create-project -s dev erik-dubbelboer/php-redis-admin /srv/utility/redis/
cp includes/config.environment.inc.php includes/config.inc.php

popd

bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait