'''
Global BYOND fixes and matchers

@author: Rob
'''
import logging
from byond.basetypes import BYONDString, BYONDValue
# from byond.directions import *

# Decorator
class MapFix(object):
    all = {}
    def __init__(self, category, _id=None):
        self.id = _id
        self.category = category
    def __call__(self, c):
        if self.id is None:
            fname_p = c.__name__
            self.id = fname_p
        print('Adding MapFix {0}-{1}.'.format(self.category, self.id))
        if self.category not in MapFix.all:
            MapFix.all[self.category] = {}
        MapFix.all[self.category][self.id] = c
        return c
    
_dependencies = {}

def DeclareDependencies(dependee, dependencies):
    if dependee not in _dependencies:
        _dependencies[dependee] = []
    _dependencies[dependee] += dependencies
    print('  Dependencies: {}'.format(dependencies))
    
def GetDependencies():
    return _dependencies

class Matcher:
    def Matches(self, atom):
        return False
    
    def Fix(self, atom):
        return atom
    
    def SetTree(self, tree):
        self.tree = tree

@MapFix(None)
class NukeTags(Matcher):
    def __init__(self):
        pass
    
    def Matches(self, atom):
        return 'tag' in atom.properties and 'tag' in atom.mapSpecified
    
    def Fix(self, atom):
        atom.mapSpecified.remove('tag')
        return atom
    
    def __str__(self):
        return 'Removed tag'
    
class RenameProperty(Matcher):
    '''
    Generic property renamer.
    '''
    
    def __init__(self, old, new):
        self.old = old
        self.new = new
        self.removed = False
        
    def Matches(self, atom):
        if self.old in atom.properties and self.old in atom.mapSpecified:
            return True
        return False
    
    def Fix(self, atom):
        if self.new not in atom.properties:  # Defer to the correct one if both exist.
            atom.properties[self.new] = atom.properties[self.old]
        if self.old in atom.mapSpecified:
            if self.new not in atom.mapSpecified:
                atom.mapSpecified += [self.new]
            else:
                self.removed = True
            atom.mapSpecified.remove(self.old)
        del atom.properties[self.old]
        return atom
    
    def __str__(self):
        if self.removed:
            return 'Removed {0}'.format(self.old)
        else:
            return 'Renamed {0} to {1}'.format(self.old, self.new)

class ChangeType(Matcher):
    def __init__(self, old, new, forcetype=False, fuzzy=False):
        self.old = old
        self.new = new
        self.forcetype = forcetype
        self.fuzzy = fuzzy
        
    def Matches(self, atom):
        matches = False
        if self.fuzzy:
            matches = atom.path.startswith(self.old)
            if matches:
                self.new += atom.path[len(self.old):]
                self.old = atom.path
                #print('{} -> {}'.format(self.old,self.new))
        else:
            matches = self.old == atom.path
        if matches:
            if atom.missing: 
                return True
            else:
                logging.warn('[{}] Found type, but marked not missing: {}'.format(self.__class__.__name__,atom.path))
                logging.warn('{}:{}: Target type found here'.format(atom.filename, atom.line))
        return False
    
    def Fix(self, atom):
        atom.path = self.new
        return atom
    
    def __str__(self):
        return 'Change type from {0} to {1}'.format(self.old, self.new)

@MapFix(None)
class FixStepX(RenameProperty):
    def __init__(self):
        RenameProperty.__init__(self, 'step_x', 'pixel_x')
        
@MapFix(None)
class FixStepY(RenameProperty):
    def __init__(self):
        RenameProperty.__init__(self, 'step_y', 'pixel_y'),

@MapFix(None)
class RepairDirections(Matcher):
    def __init__(self):
        pass
    
    def Matches(self, atom):
        return 'dir' in atom.properties and 'dir' in atom.mapSpecified and isinstance(atom.properties['dir'], BYONDString)
    
    def Fix(self, atom):
        atom.setProperty('dir', int(atom.getProperty('dir')))
        return atom
    
    def __str__(self):
        return 'Repaired direction type'
