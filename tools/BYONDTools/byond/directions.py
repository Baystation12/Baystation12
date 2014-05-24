'''
Created on Feb 23, 2013

@author: Rob
'''
import sys
# NORTH, SOUTH, EAST, and WEST are just #define statements built in DM.  
# They represent 1, 2, 4, and 8

NORTH = 1
SOUTH = 2
EAST = 4
WEST = 8

IMAGE_INDICES=[
    SOUTH,
    NORTH,
    EAST,
    WEST,
    (SOUTH|EAST),
    (SOUTH|WEST),
    (NORTH|EAST),
    (NORTH|WEST)
    ]

def getDirFromName(name):
    return getattr(sys.modules[__name__],name,None)

def getNameFromDir(_dir):
    if _dir == NORTH:
        return 'NORTH'
    elif _dir == SOUTH:
        return 'SOUTH'
    elif _dir == EAST:
        return 'EAST'
    elif _dir == WEST:
        return 'WEST'
    elif _dir == (NORTH|WEST):
        return 'NORTHWEST'
    elif _dir == (NORTH|EAST):
        return 'NORTHEAST'
    elif _dir == (SOUTH|EAST):
        return 'SOUTHEAST'
    elif _dir == (SOUTH|WEST):
        return 'SOUTHWEST'
    else:
        return 'UNKNOWN (%d)' %_dir