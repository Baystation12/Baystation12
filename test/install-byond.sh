#!/bin/sh
set -e
BYOND_VERSION="${BYOND_MAJOR}.${BYOND_MINOR}"
if [ -f ~/BYOND-${BYOND_VERSION}/byond/bin/DreamMaker ]; then
  echo "Using cached directory."
else
  echo "-- preparing directory"
  mkdir -p ~/BYOND-${BYOND_VERSION}
  cd ~/BYOND-${BYOND_VERSION}
  echo "-- installing ${BYOND_VERSION} to ${PWD} from ${BYOND_SOURCE}"
  curl -o byond.zip "${BYOND_SOURCE}/${BYOND_MAJOR}/${BYOND_VERSION}_byond_linux.zip"
  echo "-- checking received file"
  file byond.zip
  head -c 100 byond.zip
  echo "-- attempting unzip"
  unzip -o byond.zip
  cd byond
  echo "-- attempting make"
  make here
fi
