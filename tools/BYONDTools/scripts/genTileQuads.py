#!/usr/bin/env python
from byond.DMI import DMI,State
from byond import directions
import os, sys, shutil
import ImageChops
import math, operator
from PIL import Image

def rmsdiff(im1, im2):
    "Calculate the root-mean-square difference between two images"
    diff = ImageChops.difference(im1, im2)
    h = diff.histogram()
    sq = (value * (idx ** 2) for idx, value in enumerate(h))
    sum_of_squares = sum(sq)
    rms = math.sqrt(sum_of_squares / float(im1.size[0] * im1.size[1]))
    return rms

def equal(im1, im2):
    return ImageChops.difference(im1, im2).getbbox() is None
    
quadDefs = [
    # x1,y1,x2,y2
    [0,  0,  15, 15],
    [16, 0,  31, 15],
    [0,  16, 15, 31],
    [16, 16, 31, 31]
]

extract = [
    'floor',
    # 'redcorner',
    'white',
    'dark',
    'bar',
    'cafeteria',
    'redfull',
    'whiteredfull',
    'bluefull',
    'whitebluefull',
    'greenfull',
    'whitegreenfull',
    'yellowfull',
    'whiteyellowfull',
    'neutralfull',
    'orangefull',
    'purplefull',
    'whitepurplefull',
    'floorgrime',
    'brown',
    'vaultfull'
]

colors = [
    'red',
    'whitered',
    'blue',
    'whiteblue',
    'green',
    'whitegreen',
    'yellow',
    'whiteyellow',
    'neutral',
    'orange',
    'purple',
    'whitepurple',
    'grime',
    'brown',
    'vault'
]

arrangements={
    'stripe': [
        [False,False,True,True], # S
        [True,True,False,False], # N
        [False,True,False,True], # E
        [True,False,True,False], # W
        [False,True,True,True],  # SE
        [True,False,True,True],  # SW
        [True,True,False,True],  # NE
        [True,True,True,False],  # NW
    ],
    'corner': [
        [False,False,False,True], # S
        [True,False,False,False], # N
        [False,True,False,False], # E
        [False,False,True,False], # W
    ],
    'full': [
        [True,True,True,True]
    ]
}

tileDefs={
    'white':{
        'base':'white',
        'arrangements':['stripe','corner','full'],
        'colors':['whitered','whiteblue','whitegreen','whitegreen','whiteyellow','whitepurple']
    },
    'grey':{
        'base':'floor',
        'arrangements':['stripe','corner','full'],
        'colors':[
            'red',
            'blue',
            'green',
            'yellow',
            'neutral',
            'orange',
            'purple',
            'brown',
            'white'
        ]
    },
    'dark':{
        'base':'dark',
        'arrangements':['stripe','corner','full'],
        'colors':[
            'floor',
            'red',
            'blue',
            'green',
            'yellow',
            'neutral',
            'orange',
            'purple',
            'brown',
            'vault'
        ]
    }
}
knownQuads = [
    {}, {}, {}, {}
]
def isKnownQuad(i, im, icon_state):
    for name, kq in knownQuads[i].items():
        if equal(kq, im):
            return True
    return False
floors = DMI(sys.argv[1])
floors.loadAll()
basedir = 'floor_quads'
if os.path.isdir('floor_quads'):
    shutil.rmtree(basedir)
os.makedirs('floor_quads')
for icon_state in extract:
    if icon_state not in floors.states:
        print('Can\'t find state {0}!'.format(icon_state))
        continue
    for d in range(floors.states[icon_state].dirs):
        dirf = 0
        dirn = 'SOUTH'
        if floors.states[icon_state].dirs > 1:
            dirf = directions.IMAGE_INDICES[d]
            dirn = directions.getNameFromDir(dirf)
        print('{0} {1} {2}'.format(icon_state, dirn, floors.states[icon_state].dirs))
        img = floors.getFrame(icon_state, dirf, 0)
        for i in range(len(quadDefs)):
            quad = img.crop(quadDefs[i])
            if isKnownQuad(i, quad, icon_state):
                print('  Skipping quad #{}'.format(i + 1))
                continue
            color = icon_state
            if color.endswith('full'):
                color = color[:-4]
            qpath = os.path.join(basedir, str(i))
            qfile = os.path.join(qpath, '{0}.png'.format(color))
            if not os.path.isdir(qpath):
                os.makedirs(qpath)
            quad.save(qfile, 'PNG')
            knownQuads[i][color] = quad

nfloors = DMI('nfloors.dmi')
for tileName,tileDef in tileDefs.items():
    base = floors.getFrame(tileDef['base'],directions.SOUTH,0)
    for color in tileDef['colors']:
        for arrangement in tileDef['arrangements']:
            arrname=''
            arrange=[False,False,False,False]
            if isinstance(arrangement,str):
                arrange=arrangements[arrangement]
                arrname=arrangement
            elif isinstance(arrangement,list):
                arrange=arrangement[1:]
                arrname=arrangement[0]
            state='{base} {color} {arrangement}'.format(base=tileDef['base'],color=color,arrangement=arrname)
            nstate=State(state)
            nstate.dirs=len(arrange)
            nstate.frames=1
            nstate.icons=[None for _ in range(nstate.dirs)]
            #statedebug = DMI(state+'.dmi')
            nfloors.states[state]=nstate
            for d in range(len(arrange)):
                cmap = arrange[d]
                dirf = 0
                dirn = 'SOUTH'
                if len(arrange) > 1:
                    dirf = directions.IMAGE_INDICES[d]
                    dirn = directions.getNameFromDir(dirf)
                print(' Generating state {0} ({1})...'.format(repr(state),dirn))
                #print(repr(arrange))
                img=Image.new('RGBA',(32,32))
                img.paste(base)
                for i in range(len(cmap)):
                    bbox=quadDefs[i]
                    if cmap[i]:
                        img.paste(knownQuads[i][color],bbox)
                nfloors.setFrame(state, dirf, 0, img)
            #statedebug.states[state]=nfloors.states[state]
            #statedebug.save(state+'.dmi')
nfloors.save('nfloors.dmi')