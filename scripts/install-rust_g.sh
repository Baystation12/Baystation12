#!/usr/bin/env bash
set -euo pipefail

if [ -f ~/.byond/bin/librust_g.so ]; then
  echo "Using cached ~/.byond/bin/librust_g.so."
else
  echo "~/.byond/bin/librust_g.so doesn't exist! Downloading..."
  mkdir -p ~/.byond/bin
  wget -O ~/.byond/bin/librust_g.so "https://github.com/${RUST_G_REPO}/releases/download/${RUST_G_VERSION}/librust_g.so"
fi

chmod +x ~/.byond/bin/librust_g.so

echo "LDD ~/.byond/bin/librust_g.so:"
ldd ~/.byond/bin/librust_g.so
