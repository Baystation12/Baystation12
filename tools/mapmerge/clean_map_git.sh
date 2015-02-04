#!/bin/sh

for MAPFILE in ../../maps/*.dmm
do
	MAPNAME=$(basename $MAPFILE)
	git show HEAD:maps/$MAPNAME > tmp.dmm
	java -jar MapPatcher.jar -clean tmp.dmm $MAPFILE $MAPFILE
	rm tmp.dmm
done
