#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/.byond/bin
wget -O ~/.byond/bin/librust_g.so "https://github.com/ss220-space/rust-g-tg/releases/download/2.0.0-ss220/librust_g.so"
chmod +x ~/.byond/bin/librust_g.so
ldd ~/.byond/bin/librust_g.so
