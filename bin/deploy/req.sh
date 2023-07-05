#!/bin/bash

echo "update"
dnf -y update
echo "installing requirements"
dnf -y install git git-lfs make gcc-c++ findutils wget unzip
echo "requirements installed"
echo "install php"
dnf -y install dnf-utils https://mirror.dogado.de/remi/enterprise/remi-release-8.rpm && dnf -y update
dnf -y remove php
dnf -y remove php*
dnf -y module reset php
dnf -y module enable php:remi-8.2
dnf -y install php-cli
# extensions
dnf -y install php-opcache php-zip php-intl \
    php-bcmath php-json php-mbstring php-simplexml php-dom \
    php-pdo php-mysqlnd php-pgsql php-pdo_mysql php-pdo_pgsql
echo "php installed"
