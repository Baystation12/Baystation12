import os, itertools, sys
from byond.DMI import DMI
from byond.directions import SOUTH, IMAGE_INDICES
from byond.basetypes import Atom, BYONDString, BYONDValue, BYONDFileRef
# from byond.objtree import ObjectTree
from PIL import Image, ImageChops
import logging

ID_ENCODING_TABLE = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

# Cache
_icons = {}
_dmis = {}
        
def chunker(iterable, chunksize):
    """
    Return elements from the iterable in `chunksize`-ed lists. The last returned
    chunk may be smaller (if length of collection is not divisible by `chunksize`).

    >>> print list(chunker(xrange(10), 3))
    [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9]]
    """
    i = iter(iterable)
    while True:
        wrapped_chunk = [list(itertools.islice(i, int(chunksize)))]
        if not wrapped_chunk[0]:
            break
        yield wrapped_chunk.pop()

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

def BYOND2RGBA(colorstring, alpha=255):
    colorstring = colorstring.strip()
    if colorstring[0] == '#': colorstring = colorstring[1:]
    if len(colorstring) != 6:
        raise ValueError("input #%s is not in #RRGGBB format" % colorstring)
    r, g, b = colorstring[:2], colorstring[2:4], colorstring[4:]
    r, g, b = [int(n, 16) for n in (r, g, b)]
    return (r, g, b, alpha)

class Tile:
    FLAG_USE_OLD_ID = 1
    FLAG_INHERITED_PROPERTIES = 2
    
    def __init__(self, _map):
        self.origID = ''
        self.ID = 0
        self.instances = []
        self.frame = None
        self.unselected_frame = None
        self.areaSelected = True
        self.log = logging.getLogger(__name__ + '.Tile')
        self.map = _map
    
    def ID2String(self, pad=0):
        o = ''
        _id = self.ID
        IET_SIZE = len(ID_ENCODING_TABLE)
        while(_id >= len(ID_ENCODING_TABLE)):
            i = _id % IET_SIZE
            o = ID_ENCODING_TABLE[i] + o
            _id -= i
            _id /= IET_SIZE
        o = ID_ENCODING_TABLE[_id] + o
        if pad > len(o):
            o = o.rjust(pad, ID_ENCODING_TABLE[0])
        return o
    
    def GetAtoms(self):
        atoms = []
        for instance in self.instances:
            atom = self.map.getInstance(instance)
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
        return self.MapSerialize(Tile.FLAG_USE_OLD_ID)
        
    def MapSerialize(self, flags=0, padding=0):
        # "aat" = (/obj/structure/grille,/obj/structure/window/reinforced{dir = 8},/obj/structure/window/reinforced{dir = 1},/obj/structure/window/reinforced,/obj/structure/cable{d1 = 2; d2 = 4; icon_state = "2-4"; tag = ""},/turf/simulated/floor/plating,/area/security/prison)
        atoms = []
        atomFlags = 0
        if flags & Tile.FLAG_INHERITED_PROPERTIES:
            atomFlags |= Atom.FLAG_INHERITED_PROPERTIES
        for i in xrange(len(self.instances)):
            iid = self.instances[i]
            # print('{0} = {1}'.format(repr(i), repr(iid)))
            atom = self.map.getInstance(iid)
            if atom.path != '':
                atoms += [atom.MapSerialize(atomFlags)]
        if not (flags & Tile.FLAG_USE_OLD_ID):
            return '"{ID}" = ({atoms})'.format(ID=self.ID2String(padding), atoms=','.join(atoms))
        else:
            return '"{ID}" = ({atoms})'.format(ID=self.origID, atoms=','.join(atoms))
        
    def MapSerialize2(self, flags=0, padding=0):
        '''
        DMM2 serialization method.
        '''
        # "aat" = (/obj/structure/grille,/obj/structure/window/reinforced{dir = 8},/obj/structure/window/reinforced{dir = 1},/obj/structure/window/reinforced,/obj/structure/cable{d1 = 2; d2 = 4; icon_state = "2-4"; tag = ""},/turf/simulated/floor/plating,/area/security/prison)
        atomFlags = 0
        if flags & Tile.FLAG_INHERITED_PROPERTIES:
            atomFlags |= Atom.FLAG_INHERITED_PROPERTIES
        instancelist = ','.join([str(i) for i in self.GetInstances()])
        if not (flags & Tile.FLAG_USE_OLD_ID):
            return '"{ID}" = ({atoms})'.format(ID=self.ID2String(padding), atoms=instancelist)
        else:
            return '"{ID}" = ({atoms})'.format(ID=self.origID, atoms=instancelist)
    
    def __eq__(self, other):
        if len(self.instances) != len(other.instances):
            return False
        else:
            return all(self.instances[i] == other.instances[i] for i in xrange(len(self.instances)))
        
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
    
class MapLayer:
    def __init__(self, _map, height=255, width=255):
        self.map = _map
        self.min = (1, 1)
        self.max = (height, width)
        self.height = height
        self.width = width
        self.tiles = [[0 for _ in xrange(self.width)] for _ in xrange(self.height)]
        
    def SetTileAt(self, x, y, tile):
        grow = False
        if y >= self.height:
            self.height = y + 1
            grow = True
        if x >= self.width:
            self.width = x + 1
            grow = True
        if grow:
            self.grow()
        try:
            self.tiles[y][x] = tile.ID
        except IndexError:
            logging.critical('Failed to set self.tiles[{}][{}]: IndexError'.format(y, x))
            logging.critical('width: {}'.format(self.width))
            logging.critical('height: {}'.format(self.height))
            logging.critical('real width: {}'.format(len(self.tiles)))
            logging.critical('real height: {}'.format(len(self.tiles[0])))
            sys.exit(1)
    
    def grow(self):
        gamt = self.height - len(self.tiles)
        if gamt > 0:
            logging.debug('y += ' + str(gamt))
            self.tiles += [[0] for _ in xrange(gamt)]
        gamt = 0
        for y in range(len(self.tiles)):
            gamt = self.width - len(self.tiles[y])
            if gamt > 0:
                self.tiles[y] += [0 for _ in xrange(gamt)]
                logging.debug('x[{}] += {}'.format(y, gamt))
        
    def GetTileAt(self, x, y):
        # print(repr(self.tiles))
        return self.map.tileTypes[self.tiles[y][x]]
    
class MapRenderFlags:
    RENDER_STARS = 1
    RENDER_AREAS = 2
    
class Map:
    WRITE_OLD_IDS = 1
    
    READ_NO_BASE_COMP = 1
    def __init__(self, tree=None, **kwargs):
        self.filename = 'Unknown'
        self.readFlags = 0
        self.tileTypes = []
        self.instances = []
        self.zLevels = {}
        self.oldID2NewID = {}
        self.DMIs = {}
        self.width = 0
        self.height = 0
        self.idlen = 0
        self.tree = tree
        self.generatedTexAtlas = False
        self.selectedAreas = ()
        self.whitelistTypes = None
        self.forgiving_atom_lookups = kwargs.get('forgiving_atom_lookups', False)
        self.missing_atoms = set()
        
        self.log = logging.getLogger(__name__ + '.Map')

        self.duplicates = 0
        self.tileChunk2ID = {}
    
        self.atomBorders = {
            '{':'}',
            '"':'"',
            '(':')'
        }
        self.atomCache = {}
        nit = self.atomBorders.copy()
        for start, stop in self.atomBorders.items():
            if start != stop:
                nit[stop] = None
        self.atomBorders = nit
        
    def readMap(self, filename, flags=0):
        self.readFlags = flags
        if not os.path.isfile(filename):
            logging.warn('File ' + filename + " does not exist.")
        self.filename = filename
        with open(filename, 'r') as f:
            print('--- Reading tile types from {0}...'.format(self.filename))
            self.consumeTiles(f)
            print('--- Reading tile positions...')
            self.consumeTileMap(f)
            
            
        
    def writeMap(self, filename, flags=0):
        self.filename = filename
        tileFlags = 0
        if flags & Map.WRITE_OLD_IDS:
            tileFlags |= Tile.FLAG_USE_OLD_ID
        padding = len(self.tileTypes[-1].ID2String())
        with open(filename, 'w') as f:
            for tile in self.tileTypes:
                f.write('{0}\n'.format(tile.MapSerialize(tileFlags, padding)))
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
        if z < len(self.zLevels):
            return self.zLevels[z].GetTileAt(x, y)
        
    def consumeTileMap(self, f):
        zLevel = []
        y = 0
        z = 0
        inZLevel = False
        width = 0
        height = 0
        while True:
            line = f.readline()
            if line == '':
                return
            # (1,1,1) = {"
            if line.startswith('('):
                coordChunk = line[1:line.index(')')].split(',')
                # print(repr(coordChunk))
                z = int(coordChunk[2])
                zLevel = MapLayer(self, 255, 255)
                inZLevel = True
                y = 0
                width = 0
                height = 0
                continue
            if line.strip() == '"}':
                inZLevel = False
                if height == 0:
                    height = y
                newZ = MapLayer(self, height, width)
                self.zLevels[z] = newZ
                for ny in range(height):
                    for nx in range(width):
                        newZ.SetTileAt(nx, ny, zLevel.GetTileAt(nx, ny))
                self.log.info('Added map layer {0} ({1}x{2})'.format(z, height, width))
                # print(' * Added map layer {0} ({1}x{2})'.format(z, height, width))
                continue
            if inZLevel:
                if width == 0:
                    width = len(line) / self.idlen
                if width > 255:
                    logging.warn("Warning: Line is {} blocks long!".format(width))
                x = 0
                for chunk in chunker(line.strip(), self.idlen):
                    chunk = ''.join(chunk)
                    tid = self.oldID2NewID[chunk]
                    zLevel.SetTileAt(x, y, self.tileTypes[tid])
                    x += 1
                y += 1
                
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

    def consumeTiles(self, f):
        index = 0
        self.duplicates = 0
        lineNumber = 0
        self.tileChunk2ID = {}
        while True:
            line = f.readline()
            lineNumber += 1
            if line.startswith('"'):
                t = self.consumeTile(line, lineNumber)
                t.ID = index
                self.tileTypes += [t]
                self.idlen = max(self.idlen, len(t.ID2String()))
                self.oldID2NewID[t.origID] = t.ID
                index += 1
                # No longer needed, 2fast.
                # if((index % 100) == 0):
                #    print(index)
            else:
                self.log.info('-- {} tiles loaded, {} duplicates discarded'.format(index, self.duplicates))
                return 
    
    def consumeTile(self, line, lineNumber):
        t = Tile(self)
        t.origID = self.consumeTileID(line)
        tileChunk = line.strip()[line.index('(') + 1:-1]
        
        if tileChunk in self.tileChunk2ID:
            tid = self.tileChunk2ID[tileChunk]
            self.log.warn('{} duplicate of {}! Installing redirect...'.format(t.origID, tid))
            self.oldID2NewID[t.origID] = tid
            self.duplicates += 1
            return self.tileTypes[tid]
        
        t.instances = self.consumeTileAtoms(tileChunk, lineNumber)
        return t
    def getTileTypeID(self, t):
        for tile in self.tileTypes:
            if tile == t:
                return tile.ID
        return None
    
    def consumeTileID(self, line):
        e = line.index('"', 1)
        return line[1:e]
    
    def GetInstances(self):
        return self.instances
    
    # So we can read a map without parsing the tree.
    def GetAtom(self, path):
        if self.tree is not None:
            atom = self.tree.GetAtom(path)
            if atom is None and self.forgiving_atom_lookups:
                self.missing_atoms.add(path)
                return Atom(path, self.filename, missing=True)
            return atom
        return Atom(path)
    
    def consumeTileAtoms(self, line, lineNumber):
        instances = []
        atom_chunks = self.SplitAtoms(line)

        for atom_chunk in atom_chunks:
            if atom_chunk in self.atomCache:
                instances += [self.atomCache[atom_chunk]]
            else:
                atom_id = self.consumeAtom(atom_chunk, lineNumber)
                self.atomCache[atom_chunk] = atom_id
                instances += [atom_id]
            
        return instances
    
    def SplitProperties(self, string):
        o = []
        buf = []
        inString = False
        for chunk in string.split(';'):
            if not inString:
                if '"' in chunk:
                    inString = False
                    pos = 0
                    while(True):
                        pos = chunk.find('"', pos)
                        if pos == -1:
                            break
                        pc = ''
                        if pos > 0:
                            pc = chunk[pos - 1]
                        if pc != '\\':
                            inString = not inString
                        pos += 1
                    if not inString:
                        o += [chunk]
                    else:
                        buf += [chunk]
                else:
                    o += [chunk]
            else:
                if '"' in chunk:
                    o += [';'.join(buf + [chunk])]
                    inString = False
                    buf = []
                else:
                    buf += [chunk]
        return o
    
    def SplitAtoms(self, string):
        ignoreLevel = []
        
        o = []
        buf = ''
        
        string = string.rstrip()
        line_len = len(string)
        for i in xrange(line_len):
            c = string[i]
            pc = ''
            if i > 0:
                pc = string[i - 1]
            
            if c in self.atomBorders and pc != '\\':
                end = self.atomBorders[c]
                if end == c:  # Just toggle.
                    if len(ignoreLevel) > 0:
                        if ignoreLevel[-1] == c:
                            ignoreLevel.pop()
                        else:
                            ignoreLevel.append(c)
                else:
                    if end == None:
                        if len(ignoreLevel) > 0:
                            if ignoreLevel[-1] == c:
                                ignoreLevel.pop()
                    else:
                        ignoreLevel.append(end)
            if c == ',' and len(ignoreLevel) == 0:
                o += [buf]
                buf = ''
            else:
                buf += c
                    
        if len(ignoreLevel) > 0:
            print(repr(ignoreLevel))
            sys.exit()
        return o + [buf]
    
    def consumeAtom(self, line, lineNumber):
        if '{' not in line:
            atom = line.strip()
            if atom.endswith('/'):
                self.log.warn('{file}:{line}: Malformed atom: {data} has ending slash.  Stripping slashes from right side.'.format(file=self.filename, line=lineNumber, data=atom))
                atom = atom.rstrip('/')
            currentAtom = self.GetAtom(atom)
            if currentAtom is not None:
                return self.AssignIID(currentAtom)
            else:
                self.log.critical('{file}:{line}: Failed to consumeAtom({data}):  Unable to locate atom.'.format(file=self.filename, line=lineNumber, data=line))
                return None
        chunks = line.split('{')
        if len(chunks) < 2:
            self.log.error('{file}:{line}: Something went wrong in consumeAtom(). line={data}'.format(file=self.filename, line=lineNumber, data=line))
        atom = chunks[0].strip()
        if atom.endswith('/'):
            self.log.warn('{file}:{line}: Malformed atom: {data} has ending slash.  Stripping slashes from right side.'.format(file=self.filename, line=lineNumber, data=atom))
            atom = atom.rstrip('/')
        currentAtom = self.GetAtom(atom)
        if currentAtom is not None:
            currentAtom = currentAtom.copy()
        else:
            return None
        if chunks[1].endswith('}'):
            chunks[1] = chunks[1][:-1]
        property_chunks = self.SplitProperties(chunks[1])
        mapSupplied = []
        for chunk in property_chunks:
            if chunk.endswith('}'):
                chunk = chunk[:-1]
            pparts = chunk.split('=', 1)
            key = pparts[0].strip()
            value = pparts[1].strip()
            if key == '':
                self.log.warn('Ignoring property with blank name. (given {0})'.format(chunk))
                continue
            data = self.consumeDataValue(value, lineNumber)
            if key not in currentAtom.mapSpecified:
                mapSupplied += [key]
            currentAtom.properties[key] = data
        
        currentAtom.mapSpecified = mapSupplied
                
        # Compare to base
        if not (self.readFlags & Map.READ_NO_BASE_COMP):
            base_atom = self.GetAtom(currentAtom.path)
            assert base_atom != None
            # for key in base_atom.properties.keys():
            #    val = base_atom.properties[key]
            #    if key not in currentAtom.properties:
            #        currentAtom.properties[key] = val
            for key in currentAtom.properties.iterkeys():
                val = currentAtom.properties[key].value
                if key in base_atom.properties and val == base_atom.properties[key].value:
                    if key in currentAtom.mapSpecified:
                        currentAtom.mapSpecified.remove(key)
                        # print('Removed {0} from atom: Equivalent to base atom!')
                        
        return self.AssignIID(currentAtom)
                        
    def AssignIID(self, atom, replacing=None):
        if atom not in self.instances:
            if replacing is not None:
                atom.id = replacing
                self.instances[replacing] = atom
                return replacing
            else:
                atom.id = len(self.instances)
                self.instances.append(atom)
                return atom.id
        else:
            r_iid = self.instances.index(atom)
            if replacing is not None:
                self.ReplaceIIDs(replacing, r_iid)
            return r_iid
            
    def consumeDataValue(self, value, lineNumber):
        data = None
        if value[0] in ('"', "'"):
            quote = value[0]
            if quote == '"':
                data = BYONDString(value[1:-1], self.filename, lineNumber)
            elif quote == "'":
                data = BYONDFileRef(value[1:-1], self.filename, lineNumber)
        else:
            data = BYONDValue(value, self.filename, lineNumber)
        return data
    
    def getInstance(self, iid):
        if iid is None:
            return None
        return self.instances[iid] 
    
    def setInstance(self, iid, atom):
        if iid is None:
            return None
        return self.AssignIID(atom, iid)
        
    def ReplaceIIDs(self, old_iid, new_iid):
        updated = 0
        for tid in xrange(len(self.tileTypes)):
            for i in xrange(len(self.tileTypes[tid].instances)):
                if old_iid == self.tileTypes[tid].instances[i]:
                    self.tileTypes[tid].instances[i] = new_iid
                    updated += 1
        if updated > 0:
            self.log.info('Updated {0} tiles (#{1} -> #{2})'.format(updated, old_iid, new_iid))
        
