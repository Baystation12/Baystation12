#!/usr/bin/env python
"""
Usage:
    $ python calculateMaxTechLevels.py path/to/your.dme .dm

calculateMaxTechLevels.py - Get techlevels of all objects and generate reports. 

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
import os, sys, re
from byond.objtree import ObjectTree
from byond.basetypes import Atom, Proc

# Calculated Max Tech Levels.
CMTLs = {}

# All known atoms with tech origins.
AtomTechOrigins = {}

def ProcessTechLevels(atom, path=''):
    global CMTLs, AtomTechOrigins
    if path.endswith(')'):
        # print('ignoring '+path)
        return
    for key, val in atom.properties.iteritems():
        # if 'obj' in path: print('{}: {}'.format(path,key))
        if key == 'origin_tech':
            tech_origin = {}
            # materials=9;bluespace=10;magnets=3
            text_origin_tech = atom.getProperty('origin_tech', 'null')
            if text_origin_tech == 'null' or text_origin_tech == '':
                continue
            techchunks = text_origin_tech.split(';')
            for techchunk in techchunks:
                parts = techchunk.split('=')
                if len(parts) != 2:
                    print('Improperly formed origin_tech in {0}: {1}'.format(atom.path, val.value))
                    continue
                tech = parts[0]
                level = int(parts[1])
                tech_origin[tech] = level
                if tech not in CMTLs:
                    CMTLs[tech] = level
                if CMTLs[tech] < level:
                    CMTLs[tech] = level
            AtomTechOrigins[path] = tech_origin
            break
    for key, child in atom.children.iteritems():
        ProcessTechLevels(child, path + '/' + key)

def prettify(tree, indent=0):
    prefix = ' ' * indent
    for key in tree.iterkeys():
        atom = tree[key]
        print('{}{}/'.format(prefix, key))
        prettify(atom.children, indent + len(key))
        for propkey, value in atom.properties.iteritems():
            print('{}var/{} = {}'.format(' ' * (indent + len(key)), propkey, repr(value)))
        
if os.path.isfile(sys.argv[1]):
    tree = ObjectTree()
    tree.ProcessFilesFromDME(sys.argv[1])
    ProcessTechLevels(tree.Tree)
    with open(os.path.join(os.path.dirname(sys.argv[1]), 'tech_origin_list.csv'), 'w') as w:
        with open(os.path.join(os.path.dirname(sys.argv[1]), 'max_tech_origins.txt'), 'w') as mto:
            tech_columns = []
            mto.write('Calculated Max Tech Levels:\n  These tech levels have been determined by parsing ALL origin_tech variables in code included by {0}.\n'.format(sys.argv[1]))
            for tech in sorted(CMTLs.keys()):
                tech_columns.append(tech)
                mto.write('{:>15}: {}\n'.format(tech, CMTLs[tech]))
            w.write(','.join(['Atom', 'Name'] + tech_columns) + "\n")
            for path in sorted(AtomTechOrigins.keys()):
                row = []
                row.append(path)
                atom = tree.GetAtom(path)
                name = atom.properties.get('name', None)
                if name is None:
                    name = ''
                else:
                    name = name.value
                row.append('"' + name.replace('"', '""') + '"')
                for tech in tech_columns:
                    if tech in AtomTechOrigins[path]:
                        row.append(str(AtomTechOrigins[path][tech]))
                    else:
                        row.append('')
                w.write(','.join(row) + "\n")
    # prettify(tree.Tree.children)
