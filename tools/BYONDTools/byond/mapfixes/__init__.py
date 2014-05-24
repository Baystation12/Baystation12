import logging, glob, os, sys
from .base import MapFix, GetDependencies
   
def Load():
    print('Loading MapFix Modules...')
    for f in glob.glob(os.path.dirname(__file__) + "/*.py"):
        modName = 'mapfixes.' + os.path.basename(f)[:-3]
        print(' Loading module ' + modName)
        mod = __import__(modName)
        for attr in dir(mod):
            if not attr.startswith('_'):
                #print('  {} = {}'.format(attr,getattr(mod, attr)))
                globals()[attr] = getattr(mod, attr)
                
def GetFixesForNS(namespaces, load_dependencies=True):
    selected = [None] + namespaces
    depends = GetDependencies()
    if load_dependencies:
        changed = True
        while changed:
            changed = False
            for cat in selected:
                if cat is None: continue  # Global namespace is always needed.
                print('Checking dependencies for {}...'.format(cat))
                if cat in depends:
                    for newcat in depends[cat]:
                        if newcat not in selected:
                            print('Selected dependency {} (required by {})'.format(newcat,cat))
                            selected += [newcat]
                            changed = True
    o = []
    for cat in selected:
        for _, val in MapFix.all[cat].items():
            o += [val()]
    return o
