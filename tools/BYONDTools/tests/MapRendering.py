'''
Created on Feb 26, 2014

@author: Rob
'''
import unittest
#from byond.map import Map
'''
class MapRenderingTest(unittest.TestCase):
    def setUp(self):
        self.dmm = Map()
        
    def test_basic_bbox(self):
        correct_bbox=(
            3584,4382,
            3616,4414
        )
        # 1126, 440
        # 1126, 470
        
        #3584, 4288
        tile_x,tile_y=(112,134)
        
        pixel_x=0
        pixel_y=-30
        
        icon_height=32
        icon_width=32
        
        bbox = self.dmm.tilePosToBBox(tile_x, tile_y, pixel_x,pixel_y, icon_height,icon_width)
        self.assertTupleEqual(correct_bbox, bbox)

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()'''