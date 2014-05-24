'''
Created on Jan 1, 2014

@author: Rob
'''
import unittest

class MapParserTest(unittest.TestCase):
    def setUp(self):
        from byond.map import Map, Tile
        self.dmm = Map()
    
    def test_basic_SplitAtoms_operation(self):
        testStr = '/obj/effect/landmark{name = "carpspawn"},/obj/structure/lattice,/turf/space,/area'
        expectedOutput = ['/obj/effect/landmark{name = "carpspawn"}', '/obj/structure/lattice', '/turf/space', '/area']
        
        out = self.dmm.SplitAtoms(testStr)
        self.assertListEqual(out, expectedOutput)
    
    def test_basic_SplitProperties_operation(self):
        testStr = 'd1 = 1; d2 = 2; icon_state = "1-2"; tag = ""'
        expectedOutput = ['d1 = 1', ' d2 = 2', ' icon_state = "1-2"', ' tag = ""']
        
        out = self.dmm.SplitProperties(testStr)
        self.assertListEqual(out, expectedOutput)
    
    def test_basic_consumeTile_operation(self):
        from byond.map import Map, Tile
        '''
        "aaK" = (
            /obj/structure/cable{
                d1 = 1;
                d2 = 2; 
                icon_state = "1-2";
                tag = ""
            },
            /obj/machinery/atmospherics/pipe/simple/supply/hidden{
                dir = 4
            },
            /turf/simulated/floor{
                icon_state = "floorgrime"
            },
            /area/security/prison
        )
        '''
        testStr = '"aaK" = (/obj/structure/cable{d1 = 1; d2 = 2; icon_state = "1-2"; tag = ""},/obj/machinery/atmospherics/pipe/simple/supply/hidden{dir = 4},/turf/simulated/floor{icon_state = "floorgrime"},/area/security/prison)'
        out = self.dmm.consumeTile(testStr, 0)
        print('IIDs: {0}'.format(repr(out.instances)))

        self.assertEquals(out.origID, 'aaK', 'origID')
        self.assertEquals(len(out.instances), 4, 'instances size')
        self.assertEquals(len(out.GetAtom(0).properties), 4, 'instances[0] properties')
        self.assertIn('d1', out.GetAtom(0).properties, 'd1 not present in properties')
        self.assertListEqual(out.GetAtom(0).mapSpecified,['d1','d2','icon_state','tag'])
        
        self.assertEquals(len(out.GetAtom(2).properties), 1, 'Failure to parse /turf/simulated/floor{icon_state = "floorgrime"}')
        self.assertIn('icon_state', out.GetAtom(2).properties, 'Failure to parse /turf/simulated/floor{icon_state = "floorgrime"}')
        
        self.assertEqual(out.MapSerialize(Tile.FLAG_USE_OLD_ID), testStr)
        
    def test_consumeTile_landmark(self):
        from byond.map import Map, Tile
        testStr='"aah" = (/obj/effect/landmark{name = "carpspawn"},/obj/structure/lattice,/turf/space,/area)'
        out = self.dmm.consumeTile(testStr, 0)
        self.assertEqual(out.MapSerialize(Tile.FLAG_USE_OLD_ID), testStr)


if __name__ == "__main__":
    # import sys;sys.argv = ['', 'Test.testName']
    unittest.main()
