#!/bin/bash

if [[ $(uname) == MINGW* ]]
then
    if hash dm.exe 2>/dev/null
    then
        export DM='dm.exe'
        return 0
    elif [[ -a '/c/Program Files (x86)/BYOND/bin/dm.exe' ]]
    then
        export DM='/c/Program Files (x86)/BYOND/bin/dm.exe'
        return 0
    elif [[ -a '/c/Program Files/BYOND/bin/dm.exe' ]]
    then
        export DM='/c/Program Files/BYOND/bin/dm.exe'
        return 0
    fi
elif grep -Fq "Microsoft" /proc/sys/kernel/osrelease # detect WSL
then
    if hash dm.exe 2>/dev/null
    then
        export DM='dm.exe'
        return 0
    elif [[ -a '/mnt/c/Program Files (x86)/BYOND/bin/dm.exe' ]]
    then
        export DM='/mnt/c/Program Files (x86)/BYOND/bin/dm.exe'
        return 0
    elif [[ -a '/mnt/c/Program Files/BYOND/bin/dm.exe' ]]
    then
        export DM='/mnt/c/Program Files/BYOND/bin/dm.exe'
        return 0
    fi
else
    if hash DreamMaker 2>/dev/null
    then
        export DM='DreamMaker'
        return 0
    elif [[ -a '/usr/bin/DreamMaker' ]]
    then
        export DM='/usr/bin/DreamMaker'
        return 0
    elif [[ -a '/usr/share/byond/bin/DreamMaker' ]]
    then
        export DM='/usr/share/byond/bin/DreamMaker'
        return 0
    fi
fi

export DM=''
return 1
