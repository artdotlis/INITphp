#!/bin/bash

echo "clean setup"
make uninstall
# misc
dnf -y remove git git-lfs make wget gcc-c++
# TODO: some packages are colliding with systemd-udev dependencies
# dnf -y group remove "Development Tools"
# autoremove
dnf -y autoremove
# mesc
rm -r /var/cache/dnf && rm -rf /etc/pki/rpm-gpg/* && dnf clean all
echo "cleanup finished"
