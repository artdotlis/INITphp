#!/bin/bash

root_path=$(dirname "$(realpath "$0")")

echo "install project"
make build && make runBuild
mkdir -p /var/www/
mv "$root_path"/../../public/* /var/www/
echo "project installed"
