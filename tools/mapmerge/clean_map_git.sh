#!/bin/bash

shopt -s globstar

cd ../../

for MAPFILE in maps/**/*.dmm
do
	git show HEAD:$MAPFILE > tmp.dmm
	java -jar tools/mapmerge/MapPatcher.jar -clean tmp.dmm $MAPFILE $MAPFILE
	rm tmp.dmm
done
