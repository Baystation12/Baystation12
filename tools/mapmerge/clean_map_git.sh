#!/bin/sh

MAPFILE='Phoenix.dmm'

git show HEAD:maps/$MAPFILE > tmp.dmm
java -jar MapPatcher.jar -clean tmp.dmm '../../maps/'$MAPFILE '../../maps/'$MAPFILE
rm tmp.dmm
