#!/bin/bash

function compile_map {
	mapname=$1
	
	#delete the old environment file if it exists
	if [ -f $mapname.dme ]
	then
		rm $mapname.dme
	fi
	
	#copy a new one as template
	cp baystation12.dme $mapname.dme
	
	#prep it... these sed calls are ripped from scripts\dm.sh
	
	#add the MAP_OVERRIDE define to stop dreammaker complaining
	sed -i '1s!^!#define 'MAP_OVERRIDE'\n!' $mapname.dme
	
	#not sure what this does exactly, HACK HACK
	#sed -i 's!// BEGIN_INCLUDE!// BEGIN_INCLUDE\n#include "'$arg'"!' $dmepath.dme
	
	#actual map file include
	sed -i 's!#include "maps\\_map_include.dm"!#include "maps\\'$mapname'\\'$mapname'.dm"!' $mapname.dme
	
	#compile the dmb
	"$DM" "$mapname.dme"
	
	#write it out so that dreamseeker can access the list
	echo $mapname >> switchable_maps
	
	rm $mapname.dme
}

source "$( dirname "${BASH_SOURCE[0]}" )/scripts/sourcedm.sh"

if [[ $DM == "" ]]; then
    echo "Couldn't find the DreamMaker executable, aborting."
    exit 3
fi

#compile the initial dmb
"$DM" "Baystation12.dme"

#wipe the existing list of precompiled maps 
if [ -f switchable_maps ]
then
	rm switchable_maps
fi

grep "MAP_PATH=" .travis.yml | while read -r line ; do

	#make sure this line isnt commented out
	hashpos=`expr index "$line" \#`
	
	#this is a nasty hack
	zero=0
	if [ $hashpos == $zero ]
	then
		#this is a nasty hack
		linepos=`expr index "$line" H`
		linepos=`expr $linepos + 1`
		
		#we've extracted the mapname
		mapname=${line:linepos}
		
		# now compile it
		compile_map $mapname
		
	fi
done

sleep 10 #Sleep for 10 seconds
