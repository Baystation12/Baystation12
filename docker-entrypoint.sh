#!/bin/sh

mkdir /byond
chown $RUNAS:$RUNAS /byond /bs12 baystation12.rsc

gosu $RUNAS DreamDaemon baystation12.dmb 8000 -trusted -verbose
