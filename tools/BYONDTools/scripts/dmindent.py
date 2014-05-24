#!/usr/bin/env python
'''
Created on Jan 5, 2014

@author: Rob
'''
import os, sys, argparse
from byond.basetypes import Atom, Proc
from byond import objtree, GetFilesFromDME

def processFile(tree, origin, destination, args):
    atomsWritten=[]
    origin = os.path.relpath(origin)
    with open(destination, 'w') as f:
        print('>>> {0}'.format(destination))
        if args.reorganize:
            for ak in sorted(tree.Atoms.keys()):
                atom = tree.Atoms[ak]
                for a in atomsWritten:
                    if atom.path.startswith(a): continue
                #if atom.filename.replace(os.sep,'/') == sys.argv[2]:
                if atom.filename == origin:
                    f.write(atom.DumpCode())
                    atomsWritten+=[atom.path]
        else:
            for thing in tree.fileLayouts[origin]:
                ttype = thing[0]
                if ttype == 'ATOMDEF':
                    f.write(thing[1] + '\n')
                elif ttype == 'PROCDEF':
                    proc = tree.GetAtom(thing[1])
                    f.write(proc.DumpCode() + '\n')
                elif ttype == 'VAR':
                    atom = tree.GetAtom(thing[1])
                    var = atom.properties[thing[2]]
                    f.write('\t{}\n'.format(var.DumpCode(thing[2])))
                elif ttype == 'DEFINE':
                    name = thing[1]
                    value = thing[2]
                    f.write('#define {} {}\n'.format(name, value))
                elif ttype == 'UNDEF':
                    name = thing[1]
                    f.write('#undef {}\n'.format(name))
                elif ttype == 'COMMENT':
                    continue
                else: 
                    print('wot is ' + ttype + '?')
if __name__ == '__main__':
    
    opt = argparse.ArgumentParser()
    opt.add_argument('project', metavar="project.dme")
    opt.add_argument('file', metavar="file.dm", default=None, nargs='?')
    opt.add_argument('--reorganize', dest='reorganize', default=False, action='store_true', help="Reorganize the file's contents, instead of keeping current structure.")
    opt.add_argument('--output','-o', dest='output', default='', help="Where to put the output (default: <file>.fixed)")
    
    args = opt.parse_args()
        
    tree = objtree.ObjectTree(preprocessor_directives=True)
    tree.ProcessFilesFromDME(args.project)
        
    atomsWritten = []
        
    if args.file is not None and os.path.isfile(args.file):
        output=args.output
        if output=='':
            output=args.file+'.fixed'
        processFile(tree, args.file, output, args)
    else:
        for filename in GetFilesFromDME(args.project):
            fixpath = filename.replace('code' + os.sep, 'code-indented' + os.sep)
            fixpath = fixpath.replace('interface' + os.sep, 'interface-indented' + os.sep)
            fixpath = fixpath.replace('RandomZLevels' + os.sep, 'RandomZLevels-indented' + os.sep)
            fixdir = os.path.dirname(fixpath)
            if not os.path.isdir(fixdir):
                os.makedirs(fixdir)
            fixpath = fixpath.replace('/', os.sep)
            processFile(tree, filename, fixpath,args)
