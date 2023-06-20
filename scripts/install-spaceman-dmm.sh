#!/bin/bash
set -euo pipefail

if [ -f ~/spaceman_dmm/$SPACEMAN_DMM_VERSION/$1 ];
then
  echo "Using cached $1."
  cp ~/spaceman_dmm/$SPACEMAN_DMM_VERSION/$1 ~/$1
else
  wget -O ~/$1 "https://github.com/SpaceManiac/SpacemanDMM/releases/download/$SPACEMAN_DMM_VERSION/$1"
  mkdir -p ~/spaceman_dmm
  cp ~/$1 ~/spaceman_dmm/$SPACEMAN_DMM_VERSION
fi

chmod +x ~/$1
~/$1 --version
