#!/usr/bin/env bash
set -euo pipefail

sudo dpkg --add-architecture i386
sudo apt update || true
sudo apt remove -y libssl1.1:amd64 || true
sudo apt install libgcc-s1:i386
sudo apt install -o APT::Immediate-Configure=false libc6:i386
wget http://ftp.de.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1n-0+deb10u6_i386.deb
sudo dpkg -i libssl1.1_1.1.1n-0+deb10u6_i386.deb
