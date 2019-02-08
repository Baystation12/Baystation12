#!/bin/sh

mkdir /byond
chown $RUNAS:$RUNAS /byond /bs12 baystation12.rsc

mkdir cfg
echo "xales" > cfg/admin.txt

gosu $RUNAS DreamDaemon baystation12.dmb 8000 -trusted -verbose
