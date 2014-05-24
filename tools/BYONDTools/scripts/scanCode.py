#!/usr/bin/env python
import sys, re
from byond.basetypes import Proc
from byond.objtree import ObjectTree

class CodeScan:
    def __init__(self, id):
        self.id = id
        self.atom = None
        self.proc = None
        
    def SetContext(self, atom, proc):
        self.atom = atom
        self.proc = proc
        
    def MatchAtom(self, atom):
        return True
    
    def MatchProc(self, atom, proc):
        return True
    
    def ScanLine(self, line):
        return []
    
class RegexScanner(CodeScan):
    def __init__(self, id, regex, warning, in_procnames=()):
        CodeScan.__init__(self, id)
        self.regex = regex
        self.warning = warning
        self.in_procnames = in_procnames
        
    def MatchProc(self, atom, proc):
        # print(proc.path)
        return self.in_procnames == () or proc.name in self.in_procnames
    
    def ScanLine(self, line):
        m = self.regex.search(line)
        if m is not None:
            return [self.warning]
        return []
    
rules = [
    RegexScanner(
        id='sleep-in-process',
        warning='sleep() should not be used in process().',
        regex=re.compile(r'\bsleep\(([0-9]+)\)\b'),
        in_procnames=('process')
    ),
    RegexScanner(
        id='spawn-in-process',
        warning='spawn() should not be used in process().',
        regex=re.compile(r'\bspawn(\(([0-9]*)\))?\b'),
        in_procnames=('process')
    ),
    RegexScanner(
        id='del-in-ex_act',
        warning='del() should not be used in ex_act(). Consider replacing with qdel.',
        regex=re.compile(r'\bdel(\(.*\))?\b'),
        in_procnames=('ex_act')
    ),
]

otr = ObjectTree()
otr.ProcessFilesFromDME(sys.argv[1], '.dm')
procs = 0
alerts = 0
for path in otr.Atoms:
    atom = otr.GetAtom(path)
    if isinstance(atom,Proc): continue
    proceed = False
    skipping = []
    for rule in rules:
        if rule.MatchAtom(atom):
            proceed = True
        else:
            skipping += [rule]
    if not proceed: continue
    for childName in atom.children:
        warnings = {}
        child = atom.children[childName]
        if isinstance(child, Proc):
            proceed = False
            for rule in rules:
                if rule not in skipping and rule.MatchProc(atom, child):
                    proceed = True
                else:
                    skipping += [rule]
            if not proceed: continue
            
            '''
            if 'process' in path + ' - ' + childName:
                print(path + ' - ' + childName)
            '''
            # print(path + ' - ' + childName)
            procs += 1
            min_indent = child.getMinimumIndent()
            # Should be 1, so find the difference.
            indent_delta = 1 - min_indent
            for i in range(len(child.code)):
                line_warnings = []
                indent, code = child.code[i]
                indent = max(1, indent + indent_delta)
                if code.strip() == '':
                    o = '\n'
                else:
                    o = (indent * '\t') + code.strip() + '\n'
                code = o.strip('\n\r')
                for rule in rules:
                    if rule in skipping: continue
                    rule.SetContext(atom, child)
                    line_warnings += rule.ScanLine(code)
                if len(line_warnings):
                    warnings['{0}:{1}: {2}'.format(child.filename, child.line + i, code)] = line_warnings
                    alerts += len(line_warnings)
        if len(warnings) > 0:
            print('IN {0}/{1}:'.format(path, childName))
            for context in warnings:
                print('  {0}'.format(context))
                for warning in warnings[context]:
                    print('    WARNING: {0}'.format(warning))
print('{0} processed procs, {1} alerts raised'.format(procs, alerts))
