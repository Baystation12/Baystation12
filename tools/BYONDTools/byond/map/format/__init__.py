import glob, os
from .base import *

def Load():
    print('Loading Map Format Modules...')
    for f in glob.glob(os.path.dirname(__file__) + "/*.py"):
        modName = 'byond.map.format.' + os.path.basename(f)[:-3]
        print(' Loading module ' + modName)
        mod = __import__(modName)
        for attr in dir(mod):
            if not attr.startswith('_'):
                #print('  {} = {}'.format(attr,getattr(mod, attr)))
                globals()[attr] = getattr(mod, attr)