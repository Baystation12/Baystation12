
from .base import Matcher,MapFix
from byond.basetypes import BYONDString, BYONDValue, Atom, PropertyFlags
from byond.directions import *

@MapFix('ss13')
class StandardizeAPCs(Matcher):
    ACT_CLEAR_NAME = 1
    ACT_FIX_OFFSET = 2
    def __init__(self):
        self.actions = 0
        self.pixel_x = 0
        self.pixel_y = 0
        
    def Matches(self, atom):
        self.actions = 0
        if atom.path == '/obj/machinery/power/apc':
            # Determine if this APC is pretty close to standard-issue (no weird permissions, etc).
            nonstandard_settings = []
            for setting in atom.mapSpecified:
                if setting not in ('name', 'pixel_x', 'pixel_y', 'tag', 'dir'):
                    nonstandard_settings += [setting]
            if len(nonstandard_settings) > 0:
                print('Non-standard APC #{}: Has strange settings - {}'.format(atom.id,', '.join(nonstandard_settings)))
            else:
                if 'name' in atom.properties and 'name' in atom.mapSpecified:
                    self.actions |= self.ACT_CLEAR_NAME
                
            direction = int(atom.getProperty('dir', 2))
            self.pixel_x = 0
            self.pixel_y = 0
            c_pixel_x = atom.getProperty('pixel_x', 0)
            c_pixel_y = atom.getProperty('pixel_y', 0)
            if (direction & 3):
                self.pixel_x = 0
                if(direction == 1): 
                    self.pixel_y = 24 
                else:
                    self.pixel_y = -24
            else:
                self.pixel_y = 0
                if(direction == 4): 
                    self.pixel_x = 24 
                else:
                    self.pixel_x = -24
            if self.pixel_x != c_pixel_x or self.pixel_y != c_pixel_y:
                self.actions |= self.ACT_FIX_OFFSET
        return self.actions != 0
    
    def Fix(self, atom):
        if self.actions & self.ACT_CLEAR_NAME:
            atom.mapSpecified.remove('name')
        if self.actions & self.ACT_FIX_OFFSET:
            atom.setProperty('pixel_x', self.pixel_x, PropertyFlags.MAP_SPECIFIED)
            atom.setProperty('pixel_y', self.pixel_y, PropertyFlags.MAP_SPECIFIED)
        return atom
    
    def __str__(self):
        if self.actions == 0:
            return 'APC Standardization'
        descr = []
        if self.actions & self.ACT_CLEAR_NAME:
            descr += ['Cleared name property']
        if self.actions & self.ACT_FIX_OFFSET:
            descr += ['Set pixel offset to {0},{1}'.format(self.pixel_x, self.pixel_y)]
        return 'Standardized APC: ' + ', '.join(descr)