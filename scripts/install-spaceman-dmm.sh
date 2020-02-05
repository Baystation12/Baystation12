#!/bin/bash
set -euo pipefail

if [ -f "$HOME/spaceman_dmm/$SPACEMAN_DMM_VERSION/$1" ];
then
  echo "Using cached $1."
  cp "$HOME/spaceman_dmm/$SPACEMAN_DMM_VERSION/$1" ~/$1
else
  wget -O ~/$1 "https://github.com/SpaceManiac/SpacemanDMM/releases/download/$SPACEMAN_DMM_VERSION/$1"
  cp ~/$1 $HOME/spaceman_dmm/$SPACEMAN_DMM_VERSION
fi

chmod +x ~/$1
~/$1 --version
