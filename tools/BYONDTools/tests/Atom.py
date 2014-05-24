'''
Created on Jan 1, 2014

@author: Rob
'''
import unittest

class AtomTest(unittest.TestCase):
    def test_copy_consistency(self):
        from byond.basetypes import Atom, BYONDString, BYONDValue
        atom = Atom('/datum/test',__file__,0)
        atom.properties={
            'dir': BYONDValue(2),
            'name': BYONDString('test datum')
        }
        atom.mapSpecified=['dir','name']
        
        atom2=atom.copy()
        
        atom_serialized=atom.MapSerialize()
        atom2_serialized=atom2.MapSerialize()
        
        self.assertEqual(atom_serialized, atom2_serialized)

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()