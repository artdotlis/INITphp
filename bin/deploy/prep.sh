#!/bin/bash

root_path=$(dirname "$(realpath "$0")")

echo "prep setup"
dnf clean all && rm -rf /var/cache/dnf
update-ca-trust enable
update-ca-trust
dnf upgrade -y
dnf config-manager --set-enabled powertools
dnf -y install epel-release
crb enable
dnf -y install dnf-plugins-core
dnf upgrade --refresh -y
echo -e "copy health"
cp "$root_path/health.sh" / && chmod +x /health.sh
echo -e "copy entrypoint"
cp "$root_path/entry_dev.sh" / && chmod +x /entry_dev.sh
mkdir -p /docker-entrypoint.d
cp "$root_path/entry_web.sh" /docker-entrypoint.d/99-php-fpm.sh
chmod +x /docker-entrypoint.d/99-php-fpm.sh
echo "prep finished"
