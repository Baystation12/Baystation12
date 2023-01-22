#!/bin/bash

#Project dependencies file
#Final authority on what's required to fully build the project

# byond version
# Extracted from the Dockerfile. Change by editing Dockerfile's FROM command.
export BYOND_MAJOR=514
export BYOND_MINOR=1557

#rust_g git tag
export RUST_G_VERSION=1.2.0

#bsql git tag (Not sure that needed ~Laxesh)
#export BSQL_VERSION=v1.4.0.0 Not Used

#node version (Not sure that needed ~Laxesh)
#export NODE_VERSION=14
#export NODE_VERSION_PRECISE=14.16.1

# PHP version (Not sure that needed ~Laxesh)
#export PHP_VERSION=5.6

# SpacemanDMM git tag
export SPACEMAN_DMM_VERSION=suite-1.4

# Python version for mapmerge and other tools
#export PYTHON_VERSION=3.7.9
