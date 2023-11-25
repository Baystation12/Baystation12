#!/usr/bin/env bash
set -euo pipefail

sudo dpkg --add-architecture i386
sudo apt update || true
sudo apt install libgcc-s1:i386
