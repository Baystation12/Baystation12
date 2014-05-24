'''
Created on Jan 5, 2014

@author: Rob
'''
import unittest

class ObjectTreeTests(unittest.TestCase):
    def setUp(self):
        from byond.objtree import ObjectTree
        self.tree = ObjectTree()
        
    def test_consumeVariable_basics(self):
        test_string = 'var/obj/item/weapon/chainsaw = new'
        name, data = self.tree.consumeVariable(test_string, '', 0)
        
        self.assertEqual(name, 'chainsaw')
        self.assertEqual(data.type, '/obj/item/weapon')
        self.assertEqual(data.value, 'new')
        self.assertEqual(data.declaration, True)
        self.assertEqual(data.inherited, False)
        self.assertEqual(data.special, None)

    def test_consumeVariable_alternate_array_declaration_01(self):
        test_string = 'var/appearance_keylist[0]'
        name, data = self.tree.consumeVariable(test_string, '', 0)
        
        self.assertEqual(name,       'appearance_keylist')
        self.assertEqual(data.type,  '/list')
        self.assertEqual(data.value, None)
        self.assertEqual(data.size,  0)
        self.assertEqual(data.declaration, True)
        self.assertEqual(data.inherited, False)
        self.assertEqual(data.special, None)
        
    def test_consumeVariable_alternate_array_declaration_02(self):
        test_string = 'var/medical[] = list()'
        name, data = self.tree.consumeVariable(test_string, '', 0)
        
        self.assertEqual(name,       'medical')
        self.assertEqual(data.type,  '/list')
        self.assertEqual(data.value, None)
        self.assertEqual(data.size,  -1)
        self.assertEqual(data.declaration, True)
        self.assertEqual(data.inherited, False)
        self.assertEqual(data.special, None)
        
    def test_consumeVariable_complex_types(self):
        test_string = 'var/datum/gas_mixture/air_temporary'
        name, data = self.tree.consumeVariable(test_string, '', 0)
        
        self.assertEqual(name,             'air_temporary')
        self.assertEqual(data.type,        '/datum/gas_mixture')
        self.assertEqual(data.value,       None)
        self.assertEqual(data.size,        None)
        self.assertEqual(data.declaration, True)
        self.assertEqual(data.inherited,   False)
        self.assertEqual(data.special,     None)
        
    def test_consumeVariable_file_ref(self):
        test_string = 'icon = \'butts.dmi\''
        name, data = self.tree.consumeVariable(test_string, '', 0)
        
        self.assertEqual(name,             'icon')
        self.assertEqual(data.type,        '/icon')
        self.assertEqual(str(data.value),  'butts.dmi')
        self.assertEqual(data.size,        None)
        self.assertEqual(data.declaration, False)
        self.assertEqual(data.inherited,   False)
        self.assertEqual(data.special,     None)
        
if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()