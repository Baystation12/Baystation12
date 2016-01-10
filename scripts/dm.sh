#!/bin/bash
dmepath=""
retval=1
UNIT_TEST=0

for var; do
    if [[ $var != -* && $var == *.dme ]]; then
        dmepath=$(echo $var | sed -r 's/.{4}$//')
        break
    fi
done

if [[ $dmepath == "" ]]; then
    echo "No .dme file specified, aborting."
    exit 1
fi

if [[ -a $dmepath.mdme ]]; then
    rm $dmepath.mdme
fi

cp $dmepath.dme $dmepath.mdme
if [[ $? != 0 ]]; then
    echo "Failed to make modified dme, aborting."
    exit 2
fi

for var; do
    arg=$(echo $var | sed -r 's/^.{2}//')
    if [[ $var == -UNIT_TEST_FAST ]]; then
	sed -i '1s/^/#define MAP_OVERRIDE\n/' $dmepath.mdme
	sed -i '1s/^/#define UNIT_TEST\n/' $dmepath.mdme
	sed -i '1s/^/#define UNIT_TEST_NO_ZAS\n/' $dmepath.mdme
	grep -v "\.dmm" $dmepath.mdme > $dmepath.mdme_nomap
	mv $dmepath.mdme_nomap $dmepath.mdme
	sed -i 's!// BEGIN_INCLUDE!// BEGIN_INCLUDE\n#include "maps/testmap/test-10x10.dmm"!' $dmepath.mdme
	UNIT_TEST=1
    elif [[ $var == -UNIT_TEST ]]; then
	sed -i '1s/^/#define UNIT_TEST\n/' $dmepath.mdme
	UNIT_TEST=1
    elif [[ $var == -R ]]; then
	grep -v "\.dmm" $dmepath.mdme > $dmepath.mdme
    elif [[ $var == -D* ]]; then
        sed -i '1s!^!#define '$arg'\n!' $dmepath.mdme
    elif [[ $var == -I* ]]; then
        sed -i 's!// BEGIN_INCLUDE!// BEGIN_INCLUDE\n#include "'$arg'"!' $dmepath.mdme
    elif [[ $var == -M* ]]; then
        sed -i '1s/^/#define MAP_OVERRIDE\n/' $dmepath.mdme
        sed -i 's!// BEGIN_INCLUDE!// BEGIN_INCLUDE\n#include "maps\\'$arg'.dmm"!' $dmepath.mdme
    fi
done

source "$( dirname "${BASH_SOURCE[0]}" )/sourcedm.sh"

if [[ $DM == "" ]]; then
    echo "Couldn't find the DreamMaker executable, aborting."
    exit 3
fi

set -ev
"$DM" $dmepath.mdme
set +ve
mv $dmepath.mdme.dmb $dmepath.dmb
mv $dmepath.mdme.rsc $dmepath.rsc

rm $dmepath.mdme

if [[ $UNIT_TEST -eq 1 ]];then
    set -ev
    DreamDaemon $dmepath.dmb -invisible -trusted -core 2>&1 | tee log.txt
    grep -q "All Unit Tests Passed" log.txt
    (! grep "runtime error:" log.txt)
    (! grep 'Process scheduler caught exception processing' log.txt)
    set +ve
fi
