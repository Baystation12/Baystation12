#!/usr/bin/env python
'''
Created on Apr 29, 2014

@author: Rob
'''
import argparse,os

from byond.objtree import ObjectTree
from byond.basetypes import Proc

def dumpSubTypes(atom):
    print('{}:{}: {}'.format(atom.filename,atom.line,atom.path))
    for rpath,catom in atom.children.items():
        if not isinstance(catom,Proc):
            dumpSubTypes(catom)

if __name__ == '__main__':
    opt = argparse.ArgumentParser()
    opt.add_argument('project', metavar="project.dme")
    opt.add_argument('--subtypes',type=str,help="List all subtypes of the given type")
    args = opt.parse_args()
    if os.path.isfile(args.project):
        tree = ObjectTree()
        tree.ProcessFilesFromDME(args.project)
        if args.subtypes:
            atom = tree.GetAtom(args.subtypes)
            dumpSubTypes(atom)