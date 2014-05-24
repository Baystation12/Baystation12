#!/usr/bin/env python
"""
fixMap.py - Apply various fixes to a map. 

Copyright 2013 Rob "N3X15" Nelson <nexis@7chan.org>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

"""
import sys, argparse
from byond.map import Map
from byond.objtree import ObjectTree
#from byond.basetypes import BYONDString, BYONDValue, Atom, PropertyFlags
#from byond.directions import *

from byond import mapfixes


opt = argparse.ArgumentParser()  # version='0.1')
opt.add_argument('-n', '--namespace', dest='namespaces', type=str, nargs='*', default=[], help='MapFix namespace to load (ss13, vgstation).')
opt.add_argument('-N', '--no-deps', dest='no_dependencies', action='store_true', help='Stop loading of namespace dependencies.')
opt.add_argument('-f', '--fix-script', dest='fixscripts', type=str, nargs='*', help='A script that specifies property and type replacements.')

opt.add_argument('dme', nargs='?', default='baystation12.dme', type=str,help='Project file.', metavar='environment.dme')
opt.add_argument('map', type=str,help='Map to fix.', metavar='map.dmm')

args = opt.parse_args()

actions = []

mapfixes.Load()
actions += mapfixes.GetFixesForNS(args.namespaces, not args.no_dependencies)

tree = ObjectTree()
tree.ProcessFilesFromDME(args.dme)

for fixscript in args.fixscripts:
    with open(fixscript, 'r') as repl:
        ln = 0
        errors = 0
        for line in repl:
            ln += 1
            if line.startswith('#'):
                continue
            if line.strip() == '':
                continue
            # PROPERTY: step_x > pixel_x
            # TYPE: /obj/item/key > /obj/item/weapon/key/janicart
            subject, action = line.split(':')
            subject = subject.lower()
            if subject == 'property':
                old, new = action.split('>')
                actions += [mapfixes.base.RenameProperty(old.strip(), new.strip())]
            if subject == 'type' or subject == 'type!':
                force = subject == 'type!'
                old, new = action.split('>')
                newtype = new.strip()
                if tree.GetAtom(newtype) is None:
                    print('{0}:{1}: {2}'.format(sys.argv[2], ln, line.strip('\r\n')))
                    print('  ERROR: Unable to find replacement type "{0}".'.format(newtype))
                    errors += 1
                actions += [mapfixes.base.ChangeType(old.strip(), newtype, force)]
        if errors > 0:
            print('!!! {0} errors, please fix them.'.format(errors))
            sys.exit(1)
print('Changes to make:')
for action in actions:
    print(' * ' + str(action))
dmm = Map(tree, forgiving_atom_lookups=1)
dmm.readMap(args.map)
dmm.writeMap2(args.map.replace('.dmm', '.dmm2'))
for iid in xrange(len(dmm.instances)):
    atom = dmm.getInstance(iid)
    changes = []
    for action in actions:
        action.SetTree(tree)
        if action.Matches(atom):
            atom = action.Fix(atom)
            changes += [str(action)]
    atom.id = iid
    
    '''
    compiled_atom = tree.GetAtom(atom.path)
    if compiled_atom is not None:
        for propname in list(atom.properties.keys()):
            if propname not in compiled_atom.properties and propname not in ('req_access_txt','req_one_access_txt'):
                del atom.properties[propname]
                if propname in atom.mapSpecified:
                    atom.mapSpecified.remove(propname)
                changes += ['Dropped property {0} (not found in compiled atom)'.format(propname)]
    '''
    dmm.setInstance(iid, atom)
    if len(changes) > 0:
        print('{0} (#{1}):'.format(atom.path, atom.id))
        for change in changes:
            print(' * ' + change)
#for atom, _ in atomsToFix.items():
#    print('Atom {0} needs id_tag.'.format(atom))
with open(args.map + '.missing', 'w') as f:
    for atom in sorted(dmm.missing_atoms):
        f.write(atom + "\n")
print('--- Saving...')
dmm.writeMap(args.map + '.fixed', Map.WRITE_OLD_IDS)        
dmm.writeMap2(args.map.replace('.dmm', '.dmm2') + '.fixed')
