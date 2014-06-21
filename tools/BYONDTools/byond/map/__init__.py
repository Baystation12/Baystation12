"""
Map Interface Module

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
import os, itertools, sys, numpy, logging, hashlib
from byond.map.format import GetMapFormat, Load as LoadMapFormats
from byond.DMI import DMI
from byond.directions import SOUTH, IMAGE_INDICES
from byond.basetypes import Atom, BYONDString, BYONDValue, BYONDFileRef, BYOND2RGBA
# from byond.objtree import ObjectTree
from PIL import Image, ImageChops

# Cache
_icons = {}
_dmis = {}
        
LoadMapFormats()

# From StackOverflow
def trim(im):
    bg = Image.new(im.mode, im.size, im.getpixel((0, 0)))
    diff = ImageChops.difference(im, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()
    if bbox:
        return im.crop(bbox)
    
# Bytes
def tint_image(image, tint_color):
    return ImageChops.multiply(image, Image.new('RGBA', image.size, tint_color))

class TileIterator:
    def __init__(self, _map):
        self.map = _map
        self.x = -1
        self.y = 0
        self.z = 0

        self.max_z = len(self.map.zLevels)
        
    def __iter__(self):
        return self
    
    def __next__(self):
        return self.next()
    
    def next(self):
        self.x += 1
        
        zLev = self.map.zLevels[self.z]
        
        if self.x >= zLev.width:
            self.y += 1
            self.x = 0
            
        if self.y >= zLev.height:
            self.z += 1
            self.y = 0
            
        if self.z >= self.max_z:
            raise StopIteration
        
        t = self.map.GetTileAt(self.x, self.y, self.z)
        #print('{} = {}'.format((self.x,self.y,self.z),str(t)))
        return t

class Tile(object):
    def __init__(self, _map):
        self.origID = ''
        self.ID = 0
        self.instances = []
        self.frame = None
        self.unselected_frame = None
        self.areaSelected = True
        self.log = logging.getLogger(__name__ + '.Tile')
        self.map = _map
        self._hash = None
        
    def UpdateHash(self):
        if self._hash is None:
            self._hash = hashlib.md5(str(self)).hexdigest()
        
    def InvalidateHash(self):
        self._hash = None
        
    def GetHash(self):
        self.UpdateHash()
        return self._hash
        
    def RemoveAtom(self, atom, hash=True):
        '''
        :param Atom atom:
            Atom to remove.  Raises ValueError if not found.
        '''
        self.instances.remove(atom)
        self.InvalidateHash()
        if hash: self.UpdateHash()
        
    def AppendAtom(self, atom, hash=True):
        '''
        :param Atom atom:
            Atom to add.
        '''
        self.instances.append(atom)
        self.InvalidateHash()
        if hash: self.UpdateHash()
        
    def CountAtom(self, atom):
        '''
        :param Atom atom:
            Atom to count.
        :return int: Count of atoms
        '''
        return self.instances.count(atom)
    
    def copy(self, origID=False):
        tile = self.map.CreateTile()
        tile.instances = self.instances
        if origID:
            tile.origID = self.origID
        
        tile.UpdateHash()
        return tile
    
    def GetAtoms(self):
        atoms = []
        for atom in self.instances:
            if atom is None: continue
            atoms += [atom]
        return atoms
    
    def SortAtoms(self):
        return sorted(self.GetAtoms(), reverse=True)
    
    def GetAtom(self, idx):
        return self.map.getInstance(self.instances[idx])
    
    def GetInstances(self):
        return self.instances
    
    def __str__(self):
        return self._serialize()
    
    def __ne__(self, tile):
        return not self.__eq__(tile)
    
    def __eq__(self, other):
        return other and ((other._hash and self._hash and self._hash == other._hash) or (len(self.instances) == len(other.instances) and self.instances == other.instances))
        # else:
        #    return all(self.instances[i] == other.instances[i] for i in xrange(len(self.instances)))
    
    def _serialize(self):
        return ','.join([str(i) for i in self.GetInstances()])
        
    def RenderToMapTile(self, passnum, basedir, renderflags, **kwargs):
        img = Image.new('RGBA', (96, 96))
        self.offset = (32, 32)
        foundAPixelOffset = False
        render_types = kwargs.get('render_types', ())
        skip_alpha = kwargs.get('skip_alpha', False)
        # for atom in sorted(self.GetAtoms(), reverse=True):
        for atom in self.SortAtoms():
            if len(render_types) > 0:
                found = False
                for path in render_types:
                    if atom.path.startswith(path):
                        found = True
                if not found:
                    continue

            aid = atom.id
            # Ignore /areas.  They look like ass.
            if atom.path.startswith('/area'):
                if not (renderflags & MapRenderFlags.RENDER_AREAS):
                    continue
            
            # We're going to turn space black for smaller images.
            if atom.path == '/turf/space':
                if not (renderflags & MapRenderFlags.RENDER_STARS):
                    continue
                
            if 'icon' not in atom.properties:
                logging.critical('UNKNOWN ICON IN {0} (atom #{1})'.format(self.origID, aid))
                logging.info(atom.MapSerialize())
                logging.info(atom.MapSerialize(Atom.FLAG_INHERITED_PROPERTIES))
                continue
            
            dmi_file = atom.properties['icon'].value
            
            if 'icon_state' not in atom.properties:
                # Grab default icon_state ('') if we can't find the one defined.
                atom.properties['icon_state'] = BYONDString("")
            
            state = atom.properties['icon_state'].value
            
            direction = SOUTH
            if 'dir' in atom.properties:
                try:
                    direction = int(atom.properties['dir'].value)
                except ValueError:
                    logging.critical('FAILED TO READ dir = ' + repr(atom.properties['dir'].value))
                    continue
            
            icon_key = '{0}|{1}|{2}'.format(dmi_file, state, direction)
            frame = None
            pixel_x = 0
            pixel_y = 0
            if icon_key in _icons:
                frame, pixel_x, pixel_y = _icons[icon_key]
            else:
                dmi_path = os.path.join(basedir, dmi_file)
                dmi = None
                if dmi_path in _dmis:
                    dmi = _dmis[dmi_path]
                else:
                    try:
                        dmi = DMI(dmi_path)
                        dmi.loadAll()
                        _dmis[dmi_path] = dmi
                    except Exception as e:
                        print(str(e))
                        for prop in ['icon', 'icon_state', 'dir']:
                            print('\t{0}'.format(atom.dumpPropInfo(prop)))
                        pass
                if dmi.img is None:
                    logging.warning('Unable to open {0}!'.format(dmi_path))
                    continue
                
                if dmi.img.mode not in ('RGBA', 'P'):
                    logging.warn('{} is mode {}!'.format(dmi_file, dmi.img.mode))
                    
                if direction not in IMAGE_INDICES:
                    logging.warn('Unrecognized direction {} on atom {} in tile {}!'.format(direction, atom.MapSerialize(), self.origID))
                    direction = SOUTH  # DreamMaker property editor shows dir = 2.  WTF?
                    
                frame = dmi.getFrame(state, direction, 0)
                if frame == None:
                    # Get the error/default state.
                    frame = dmi.getFrame("", direction, 0)
                
                if frame == None:
                    continue
                
                if frame.mode != 'RGBA':
                    frame = frame.convert("RGBA")
                    
                pixel_x = 0
                if 'pixel_x' in atom.properties:
                    pixel_x = int(atom.properties['pixel_x'].value)
                    
                pixel_y = 0
                if 'pixel_y' in atom.properties:
                    pixel_y = int(atom.properties['pixel_y'].value)
                
                _icons[icon_key] = (frame, pixel_x, pixel_y)
                    
            # Handle BYOND alpha and coloring
            c_frame = frame
            alpha = int(atom.getProperty('alpha', 255))
            if skip_alpha:
                alpha = 255
            color = atom.getProperty('color', '#FFFFFF')
            if alpha != 255 or color != '#FFFFFF':
                c_frame = tint_image(frame, BYOND2RGBA(color, alpha))
            img.paste(c_frame, (32 + pixel_x, 32 - pixel_y), c_frame)  # Add to the top of the stack.
            if pixel_x != 0 or pixel_y != 0:
                if passnum == 0: return  # Wait for next pass
                foundAPixelOffset = True
        
        if passnum == 1 and not foundAPixelOffset:
            return None
        if not self.areaSelected:
            # Fade out unselected tiles.
            bands = list(img.split())
            # Excluding alpha band
            for i in range(3):
                bands[i] = bands[i].point(lambda x: x * 0.4)
            img = Image.merge(img.mode, bands)
        
        return img
    
vTile = numpy.vectorize(Tile)

class MapLayer:
    def __init__(self, _map, height=255, width=255):
        self.map = _map
        self.min = (1, 1)
        self.max = (height, width)
        self.height = height
        self.width = width
        self.tiles = numpy.empty((height, width), object)
        
        self.tiles[:, :] = vTile(self)
        
    def Resize(self,height,width):
        self.height=height
        self.width=width
        self.tiles.resize(height,width)
    
class MapRenderFlags:
    RENDER_STARS = 1
    RENDER_AREAS = 2
    
class Map:
    def __init__(self, tree=None, **kwargs):
        self.zLevels = []
        self.DMIs = {}
        self.tree = tree
        self.generatedTexAtlas = False
        self.selectedAreas = ()
        self.whitelistTypes = None
        self.forgiving_atom_lookups = kwargs.get('forgiving_atom_lookups', False)
        
        self.log = logging.getLogger(__name__ + '.Map')
        
    def CreateZLevel(self, height, width, z= -1):
        zLevel = MapLayer(self, height, width)
        if z >= 0:
            self.zLevels[z] = zLevel
        else:
            self.zLevels.append(zLevel)
        return zLevel
    
    def Tiles(self):
        return TileIterator(self)
    
    def Load(self, filename, **kwargs):
        _, ext = os.path.splitext(filename)
        fmt=kwargs.get('format','dmm2' if ext=='dmm2' else 'dmm')
        reader = GetMapFormat(self, fmt)
        reader.Load(filename, **kwargs)
    
    def Save(self, filename, **kwargs):
        _, ext = os.path.splitext(filename)
        fmt=kwargs.get('format','dmm2' if ext=='dmm2' else 'dmm')
        reader = GetMapFormat(self, kwargs.get('format',fmt))
        reader.Save(filename, **kwargs)
        
    def writeMap2(self, filename, flags=0):
        self.filename = filename
        tileFlags = 0
        atomFlags = 0
        if flags & Map.WRITE_OLD_IDS:
            tileFlags |= Tile.FLAG_USE_OLD_ID
            atomFlags |= Atom.FLAG_USE_OLD_ID
        padding = len(self.tileTypes[-1].ID2String())
        with open(filename, 'w') as f:
            f.write('// Atom Instances\n')
            for atom in self.instances:
                f.write('{0} = {1}\n'.format(atom.id, atom.MapSerialize(atomFlags)))
            f.write('// Tiles\n')
            for tile in self.tileTypes:
                f.write('{0}\n'.format(tile.MapSerialize2(tileFlags, padding)))
            f.write('// Layout\n')
            for z in self.zLevels.keys():
                f.write('\n(1,1,{0}) = {{"\n'.format(z))
                zlevel = self.zLevels[z]
                for y in xrange(zlevel.height):
                    for x in xrange(zlevel.width):
                        tile = zlevel.GetTileAt(x, y)
                        if flags & Map.WRITE_OLD_IDS:
                            f.write(tile.origID)
                        else:
                            f.write(tile.ID2String(padding))
                    f.write("\n")
                f.write('"}\n')
                
    def GetTileAt(self, x, y, z):
        '''
        :param int x:
        :param int y:
        :param int z:
        :rtype Tile:
        '''
        if z < len(self.zLevels):
            return self.zLevels[z].tiles[x, y]
                
    def CopyTileAt(self, x, y, z):
        '''
        :param int x:
        :param int y:
        :param int z:
        :rtype Tile:
        '''
        if z < len(self.zLevels):
            return self.zLevels[z].tiles[x, y].copy()
                
    def SetTileAt(self, x, y, z, tile):
        '''
        :param int x:
        :param int y:
        :param int z:
        '''
        if z < len(self.zLevels):
            self.zLevels[z].tiles[x, y] = tile
                
    def CreateTile(self):
        '''
        :rtype Tile:
        '''
        return Tile(self)
                
    def generateTexAtlas(self, basedir, renderflags=0):
        if self.generatedTexAtlas:
            return
        print('--- Generating texture atlas...')
        self._icons = {}
        self._dmis = {}
        self.generatedTexAtlas = True
        for tid in xrange(len(self.tileTypes)):
            tile = self.tileTypes[tid]
            img = Image.new('RGBA', (96, 96))
            tile.offset = (32, 32)
            tile.areaSelected = True
            tile.render_deferred = False
            for atom in sorted(tile.GetAtoms(), reverse=True):
                
                aid = atom.id
                # Ignore /areas.  They look like ass.
                if atom.path.startswith('/area'):
                    if not (renderflags & MapRenderFlags.RENDER_AREAS):
                        continue
                
                # We're going to turn space black for smaller images.
                if atom.path == '/turf/space':
                    if not (renderflags & MapRenderFlags.RENDER_STARS):
                        continue
                    
                if 'icon' not in atom.properties:
                    print('CRITICAL: UNKNOWN ICON IN {0} (atom #{1})'.format(tile.origID, aid))
                    print(atom.MapSerialize())
                    print(atom.MapSerialize(Atom.FLAG_INHERITED_PROPERTIES))
                    continue
                
                dmi_file = atom.properties['icon'].value
                
                if 'icon_state' not in atom.properties:
                    # Grab default icon_state ('') if we can't find the one defined.
                    atom.properties['icon_state'] = BYONDString("")
                
                state = atom.properties['icon_state'].value
                
                direction = SOUTH
                if 'dir' in atom.properties:
                    try:
                        direction = int(atom.properties['dir'].value)
                    except ValueError:
                        print('FAILED TO READ dir = ' + repr(atom.properties['dir'].value))
                        continue
                
                icon_key = '{0}:{1}[{2}]'.format(dmi_file, state, direction)
                frame = None
                pixel_x = 0
                pixel_y = 0
                if icon_key in self._icons:
                    frame, pixel_x, pixel_y = self._icons[icon_key]
                else:
                    dmi_path = os.path.join(basedir, dmi_file)
                    dmi = None
                    if dmi_path in self._dmis:
                        dmi = self._dmis[dmi_path]
                    else:
                        try:
                            dmi = self.loadDMI(dmi_path)
                            self._dmis[dmi_path] = dmi
                        except Exception as e:
                            print(str(e))
                            for prop in ['icon', 'icon_state', 'dir']:
                                print('\t{0}'.format(atom.dumpPropInfo(prop)))
                            pass
                        
                    if dmi.img is None:
                        self.log.warn('Unable to open {0}!'.format(dmi_path))
                        continue
                    
                    if dmi.img.mode not in ('RGBA', 'P'):
                        self.log.warn('{} is mode {}!'.format(dmi_file, dmi.img.mode))
                        
                    if direction not in IMAGE_INDICES:
                        self.log.warn('Unrecognized direction {} on atom {} in tile {}!'.format(direction, atom.MapSerialize(), tile.origID))
                        direction = SOUTH  # DreamMaker property editor shows dir = 2.  WTF?
                        
                    frame = dmi.getFrame(state, direction, 0)
                    if frame == None:
                        # Get the error/default state.
                        frame = dmi.getFrame("", direction, 0)
                    
                    if frame == None:
                        continue
                    
                    if frame.mode != 'RGBA':
                        frame = frame.convert("RGBA")
                        
                    pixel_x = 0
                    if 'pixel_x' in atom.properties:
                        pixel_x = int(atom.properties['pixel_x'].value)
                        
                    pixel_y = 0
                    if 'pixel_y' in atom.properties:
                        pixel_y = int(atom.properties['pixel_y'].value)
                        
                    self._icons[icon_key] = (frame, pixel_x, pixel_y)
                img.paste(frame, (32 + pixel_x, 32 - pixel_y), frame)  # Add to the top of the stack.
                if pixel_x != 0 or pixel_y != 0:
                    tile.render_deferred = True
            tile.frame = img
            
            # Fade out unselected tiles.
            bands = list(img.split())
            # Excluding alpha band
            for i in range(3):
                bands[i] = bands[i].point(lambda x: x * 0.4)
            tile.unselected_frame = Image.merge(img.mode, bands)
            
            self.tileTypes[tid] = tile
                
    def renderAtom(self, atom, basedir, skip_alpha=False):
        if 'icon' not in atom.properties:
            logging.critical('UNKNOWN ICON IN ATOM #{0} ({1})'.format(atom.id, atom.path))
            logging.info(atom.MapSerialize())
            logging.info(atom.MapSerialize(Atom.FLAG_INHERITED_PROPERTIES))
            return None
        # else:
        #    logging.info('Icon found for #{}.'.format(atom.id))
        
        dmi_file = atom.properties['icon'].value
        
        if dmi_file is None:
            return None
        
        # Grab default icon_state ('') if we can't find the one defined.
        state = atom.getProperty('icon_state', '')
        
        direction = SOUTH
        if 'dir' in atom.properties:
            try:
                direction = int(atom.properties['dir'].value)
            except ValueError:
                logging.critical('FAILED TO READ dir = ' + repr(atom.properties['dir'].value))
                return None
        
        icon_key = '{0}|{1}|{2}'.format(dmi_file, state, direction)
        frame = None
        pixel_x = 0
        pixel_y = 0
        if icon_key in _icons:
            frame, pixel_x, pixel_y = _icons[icon_key]
        else:
            dmi_path = os.path.join(basedir, dmi_file)
            dmi = None
            if dmi_path in _dmis:
                dmi = _dmis[dmi_path]
            else:
                try:
                    dmi = DMI(dmi_path)
                    dmi.loadAll()
                    _dmis[dmi_path] = dmi
                except Exception as e:
                    print(str(e))
                    for prop in ['icon', 'icon_state', 'dir']:
                        print('\t{0}'.format(atom.dumpPropInfo(prop)))
                    pass
            if dmi.img is None:
                logging.warning('Unable to open {0}!'.format(dmi_path))
                return None
            
            if dmi.img.mode not in ('RGBA', 'P'):
                logging.warn('{} is mode {}!'.format(dmi_file, dmi.img.mode))
                
            if direction not in IMAGE_INDICES:
                logging.warn('Unrecognized direction {} on atom {}!'.format(direction, atom.MapSerialize()))
                direction = SOUTH  # DreamMaker property editor shows dir = 2.  WTF?
                
            frame = dmi.getFrame(state, direction, 0)
            if frame == None:
                # Get the error/default state.
                frame = dmi.getFrame("", direction, 0)
            
            if frame == None:
                return None
            
            if frame.mode != 'RGBA':
                frame = frame.convert("RGBA")
                
            pixel_x = 0
            if 'pixel_x' in atom.properties:
                pixel_x = int(atom.properties['pixel_x'].value)
                
            pixel_y = 0
            if 'pixel_y' in atom.properties:
                pixel_y = int(atom.properties['pixel_y'].value)
            
            _icons[icon_key] = (frame, pixel_x, pixel_y)
                
        # Handle BYOND alpha and coloring
        c_frame = frame
        alpha = int(atom.getProperty('alpha', 255))
        if skip_alpha:
            alpha = 255
        color = atom.getProperty('color', '#FFFFFF')
        if alpha != 255 or color != '#FFFFFF':
            c_frame = tint_image(frame, BYOND2RGBA(color, alpha))
        return c_frame
    
    def generateImage(self, filename_tpl, basedir='.', renderflags=0, z=None, **kwargs):
        '''
        Instead of generating on a tile-by-tile basis, this creates a large canvas and places
        each atom on it after sorting layers.  This resolves the pixel_(x,y) problem.
        '''
        if z is None:
            for z in self.zLevels.keys():
                self.generateImage(filename_tpl, basedir, renderflags, z, **kwargs)
            return
        self.selectedAreas = ()
        skip_alpha = False
        render_types = ()
        if 'area' in kwargs:
            self.selectedAreas = kwargs['area']
        if 'render_types' in kwargs:
            render_types = kwargs['render_types']
        if 'skip_alpha' in kwargs:
            skip_alpha = kwargs['skip_alpha']
            
        print('Checking z-level {0}...'.format(z))
        instancePositions = {}
        for y in range(self.zLevels[z].height):
            for x in range(self.zLevels[z].width):
                t = self.zLevels[z].GetTileAt(x, y)
                # print('*** {},{}'.format(x,y))
                if t is None:
                    continue
                if len(self.selectedAreas) > 0:
                    renderThis = True
                    for atom in t.GetAtoms():
                        if atom.path.startswith('/area'):
                            if  atom.path not in self.selectedAreas:
                                renderThis = False
                    if not renderThis: continue
                for atom in t.GetAtoms():
                    if atom is None: continue
                    iid = atom.id
                    if atom.path.startswith('/area'):
                        if  atom.path not in self.selectedAreas:
                            continue
                            
                    # Check for render restrictions
                    if len(render_types) > 0:
                        found = False
                        for path in render_types:
                            if atom.path.startswith(path):
                                found = True
                        if not found:
                            continue

                    # Ignore /areas.  They look like ass.
                    if atom.path.startswith('/area'):
                        if not (renderflags & MapRenderFlags.RENDER_AREAS):
                            continue
                    
                    # We're going to turn space black for smaller images.
                    if atom.path == '/turf/space':
                        if not (renderflags & MapRenderFlags.RENDER_STARS):
                            continue
                        
                    if iid not in instancePositions:
                        instancePositions[iid] = []
                        
                    # pixel offsets
                    '''
                    pixel_x = int(atom.getProperty('pixel_x', 0))
                    pixel_y = int(atom.getProperty('pixel_y', 0))
                    t_o_x = int(round(pixel_x / 32))
                    t_o_y = int(round(pixel_y / 32))
                    pos = (x + t_o_x, y + t_o_y)
                    '''
                    pos = (x, y)
                    
                    instancePositions[iid].append(pos)
        
        if len(instancePositions) == 0:
            return
        
        levelAtoms = []
        for iid in instancePositions:
            levelAtoms += [self.getInstance(iid)]
        
        pic = Image.new('RGBA', ((self.zLevels[z].width + 2) * 32, (self.zLevels[z].height + 2) * 32), "black")
            
        # Bounding box, used for cropping.
        bbox = [99999, 99999, 0, 0]
            
        # Replace {z} with current z-level.
        filename = filename_tpl.replace('{z}', str(z))
        
        pastes = 0
        for atom in sorted(levelAtoms, reverse=True):
            if atom.id not in instancePositions:
                continue
            icon = self.renderAtom(atom, basedir, skip_alpha)
            if icon is None:
                continue
            for x, y in instancePositions[atom.id]:
                new_bb = self.getBBoxForAtom(x, y, atom, icon)
                # print('{0},{1} = {2}'.format(x, y, new_bb))
                # Adjust cropping bounds 
                if new_bb[0] < bbox[0]:
                    bbox[0] = new_bb[0]
                if new_bb[1] < bbox[1]:
                    bbox[1] = new_bb[1]
                if new_bb[2] > bbox[2]:
                    bbox[2] = new_bb[2]
                if new_bb[3] > bbox[3]:
                    bbox[3] = new_bb[3]
                pic.paste(icon, new_bb, icon)
                pastes += 1
            
        if len(self.selectedAreas) == 0:            
            # Autocrop (only works if NOT rendering stars or areas)
            pic = trim(pic)
        else:
            # if nSelAreas == 0:
            #    continue
            pic = pic.crop(bbox)
        
        if pic is not None:
            # Saev
            filedir = os.path.dirname(filename)
            if not os.path.isdir(filedir):
                os.makedirs(filedir)
            print(' -> {} ({}x{}) - {} objects'.format(filename, pic.size[0], pic.size[1], pastes))
            pic.save(filename, 'PNG')
                
    def getBBoxForAtom(self, x, y, atom, icon):
        icon_width, icon_height = icon.size
        pixel_x = int(atom.getProperty('pixel_x', 0))
        pixel_y = int(atom.getProperty('pixel_y', 0))

        return self.tilePosToBBox(x, y, pixel_x, pixel_y, icon_height, icon_width)
                
    def tilePosToBBox(self, tile_x, tile_y, pixel_x, pixel_y, icon_height, icon_width):
        # Tile Pos
        X = tile_x * 32
        Y = tile_y * 32
        
        # pixel offsets
        X += pixel_x
        Y -= pixel_y
        
        # BYOND coordinates -> PIL coords.
        # BYOND uses LOWER left.
        # PIL uses UPPER left
        X += 0
        Y += 32 - icon_height

        return (
            X,
            Y,
            X + icon_width,
            Y + icon_height
        )
    
    # So we can read a map without parsing the tree.
    def GetAtom(self, path):
        if self.tree is not None:
            atom = self.tree.GetAtom(path)
            if atom is None and self.forgiving_atom_lookups:
                self.missing_atoms.add(path)
                return Atom(path, self.filename, missing=True)
            return atom
        return Atom(path)
        
