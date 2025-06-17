#!/bin/sh
set -e
if [ -f ~/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}/byond/bin/DreamMaker ];
then
  echo "Using cached directory."
else
  echo "Setting up BYOND."
  mkdir -p ~/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}
  cd ~/BYOND-${BYOND_MAJOR}.${BYOND_MINOR}
  echo "Installing DreamMaker to $PWD"
  curl "https://indm.dev/byond/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip
  unzip -o byond.zip
  cd byond
  make here
fi
