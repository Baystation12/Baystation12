#!/usr/bin/env python
'''
Created on Feb 28, 2014 to test a bug in DreamMaker.

Requires arial font.
'''
from byond.DMI import DMI, State
from PIL import Image, ImageDraw, ImageFont

def makeDMI():
    dmi = DMI('state_limit.dmi')
    #
    for i in range(513):
        # Make a new tile
        img = Image.new('RGBA', (32, 32))
        # Set up PIL's drawing stuff
        draw = ImageDraw.Draw(img)
        # Define a font.
        font = ImageFont.truetype('arial.ttf', 10)
        # Draw the tile number
        draw.text((10, 0), str(i + 1), (0, 0, 0), font=font)
        # Make state
        state_name='state {0}'.format(i+1)
        state=State(state_name)
        state.dirs=1
        state.frames=1
        state.icons=[img]
        # Add state to DMI
        dmi.states[state_name]=state
    #save
    dmi.save('state_limit.dmi', sort=False)
if __name__ == '__main__':
    makeDMI()
