from byond.basetypes import *
from byond.utils import getElapsed
# from byond.map import Tile, MapLayer
from byond.map.format.base import BaseMapFormat, MapFormat
import os, sys, logging, itertools, shutil, collections, math
from time import clock

ID_ENCODING_TABLE = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
IET_SIZE = len(ID_ENCODING_TABLE)

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
        
def DMMSortAlg(v):
    t = (v.upper(),)
    l = [c.isupper() for c in v]
    l.reverse()
    return t + tuple(l)

@MapFormat('dmm')
class DMMFormat(BaseMapFormat):
    def __init__(self, map):
        BaseMapFormat.__init__(self, map)
        
        self.tileTypes = []
        self.instances = []
        self.oldID2NewID = {}
        self.log = logging.getLogger('DMMFormat')
        
        self.filename = 'BUILT-IN?'
        
        # Number of duplicates found when loading.
        self.duplicates = 0
        
        # Caches
        self.tileChunk2ID = {}
        self.atomCache = {}
    
        self.atomBorders = {
            '{':'}',
            '"':'"',
            '(':')'
        }
        nit = self.atomBorders.copy()
        for start, stop in self.atomBorders.items():
            if start != stop:
                nit[stop] = None
        self.atomBorders = nit
        self.idlen = 0
        
        self.dump_inherited = False
        
    def Load(self, filename, **kwargs):
        if not os.path.isfile(filename):
            self.log.warn('File ' + filename + " does not exist.")
        self.filename = filename
        with open(filename, 'r') as f:
            print('Reading tile types from {0}...'.format(self.filename))
            self.consumeTiles(f)
            print('Reading tile positions...')
            self.consumeTileMap(f)
            
    def consumeDataValue(self, value, lineNumber):
        data = None
        if value[0] in ('"', "'"):
            quote = value[0]
            if quote == '"':
                data = BYONDString(value[1:-1], self.filename, lineNumber)
            elif quote == "'":
                data = BYONDFileRef(value[1:-1], self.filename, lineNumber)
        elif value == 'null':
            data = BYONDValue(None, self.filename, lineNumber)
        else:
            data = BYONDValue(value, self.filename, lineNumber)
        return data
    def consumeTileMap(self, f):
        zLevel = None
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
                inZLevel = True
                y = 0
                width = 0
                height = 0
                continue
            if line.strip() == '"}':
                inZLevel = False
                if height == 0:
                    height = y
                # self.map.zLevels[z] = zLevel
                zLevel = None
                # self.log.info('Added map layer {0} ({1}x{2})'.format(z, height, width))
                print(' * Added map layer {0} ({1}x{2})'.format(z, height, width))
                continue
            if inZLevel:
                if zLevel is None:
                    zLevel = self.map.CreateZLevel(height, width)  # , z-1)
                if width == 0:
                    width = len(line) / self.idlen
                    # print('Width detected as {}.'.format(width))
                    zLevel.Resize(width, width)
                if width > 255:
                    logging.warn("Line is {} blocks long!".format(width))
                x = 0
                for chunk in chunker(line.strip(), self.idlen):
                    chunk = self.String2ID(''.join(chunk))
                    tid = self.oldID2NewID[chunk]
                    zLevel.tiles[x, y] = self.tileTypes[tid].copy(origID=True)
                    x += 1
                y += 1
                
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
                t.UpdateHash()
                self.tileTypes += [t]
                self.idlen = max(self.idlen, len(self.ID2String(t.ID)))
                self.oldID2NewID[t.origID] = t.ID
                index += 1
                # No longer needed, 2fast.
                # if((index % 100) == 0):
                #   print(index)
            else:
                self.log.info('-- {} tiles loaded, {} duplicates discarded'.format(index, self.duplicates))
                return 
    
    def consumeTileAtoms(self, line, lineNumber):
        instances = []
        atom_chunks = self.SplitAtoms(line)

        for atom_chunk in atom_chunks:
            if atom_chunk in self.atomCache:
                instances += [self.atomCache[atom_chunk]]
            else:
                atom = self.consumeAtom(atom_chunk, lineNumber)
                self.atomCache[atom_chunk] = atom
                instances += [atom]
            
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
    
    def consumeAtom(self, line, lineNumber=0):
        if '{' not in line:
            atom = line.strip()
            if atom.endswith('/'):
                self.log.warn('{file}:{line}: Malformed atom: {data} has ending slash.  Stripping slashes from right side.'.format(file=self.filename, line=lineNumber, data=atom))
                atom = atom.rstrip('/')
            currentAtom = self.map.GetAtom(atom)
            if currentAtom is not None:
                return currentAtom
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
        currentAtom = self.map.GetAtom(atom)
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
        if True:  # TODO: not (self.readFlags & Map.READ_NO_BASE_COMP):
            base_atom = self.map.GetAtom(currentAtom.path)
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
                        
        return currentAtom
        
    def consumeTile(self, line, lineNumber):
        t = self.map.CreateTile()
        t.origID = self.consumeTileID(line)
        tileChunk = line.strip()[line.index('(') + 1:-1]
        
        if tileChunk in self.tileChunk2ID:
            tid = self.tileChunk2ID[tileChunk]
            print('{} duplicate of {}! Installing redirect...'.format(t.origID, tid))
            self.oldID2NewID[t.origID] = tid
            self.duplicates += 1
            return self.tileTypes[tid]
        self.tileChunk2ID[tileChunk]=t.origID
        t.instances = self.consumeTileAtoms(tileChunk, lineNumber)
        if t.origID == 0:
            print('{} -> {}'.format(t.origID,tileChunk))
            print('AKA {}'.format(str(t)))
        return t
    
    def consumeTileID(self, line):
        e = line.index('"', 1)
        return self.String2ID(line[1:e])
            
    def SerializeAtom(self, atom):
        atomContents = []
        # print(repr(self.mapSpecified))
        if self.dump_inherited:
            for key, val in atom.properties.items():
                atomContents += ['{0} = {1}'.format(key, val)]
        else:
            for i in range(len(atom.mapSpecified)):
                key = atom.mapSpecified[i]
                if key in atom.properties:
                    val = atom.properties[key]
                    atomContents += ['{0} = {1}'.format(key, val)]
        if len(atomContents) > 0:
            return atom.path + '{' + '; '.join(atomContents) + '}'
        else:
            return atom.path
            
    def SerializeTile(self, tile):
        # "aat" = (/obj/structure/grille,/obj/structure/window/reinforced{dir = 8},/obj/structure/window/reinforced{dir = 1},/obj/structure/window/reinforced,/obj/structure/cable{d1 = 2; d2 = 4; icon_state = "2-4"; tag = ""},/turf/simulated/floor/plating,/area/security/prison)
        atoms = []
        if tile.origID == 0:
            print(str(tile))
            print('len = {}'.format(len(tile.instances)))
        for i in xrange(len(tile.instances)):
            atom = tile.instances[i]
            if atom.path != '':
                atoms += [self.SerializeAtom(atom)]

        return '({atoms})'.format(atoms=','.join(atoms))
    
    def ID2String(self, _id, pad=0):
        o = ''
        while(_id >= len(ID_ENCODING_TABLE)):
            i = _id % IET_SIZE
            o = ID_ENCODING_TABLE[i] + o
            _id -= i
            _id /= IET_SIZE
        o = ID_ENCODING_TABLE[_id] + o
        if pad > len(o):
            o = o.rjust(pad, ID_ENCODING_TABLE[0])
        return o
    
    def String2ID(self, _id):
        o = 0
        for i, c in enumerate(reversed(_id)):
            o += ID_ENCODING_TABLE.index(c) * (IET_SIZE ** i)
        return o
    
    def AssignTID(self, tile):
        '''
        :param tile Tile:
            Tile to assign ID to.
        '''
        if tile not in self.tileTypes:
            self.tileTypes.append(tile)
        tile.ID = self.tileTypes.index(tile)
        return self.ID2String(tile)
    
    def GetTID(self, tile):
        # print('GetTID: origID: {}'.format(repr(tile.origID)))
        if self.serialize_cleanly and tile.origID != '':
            return tile.origID
        else:
            return tile.ID
    
    def Save(self, filename, **kwargs):
        self.filename = filename
        
        self.tileTypes = []
        examined = []
        hashMap = {}
        self.typeMap = {}
        self.type2TID = {}
        self.instances = []
        
        self.serialize_cleanly = kwargs.get('clean', True)
        self.dump_inherited = kwargs.get('inherited', False)
        
        #print('"aaa" = {}'.format(self.map.GetTileAt(0,0,0)))
        
        # Preprocess and assign IDs.
        idlen = 0
        it = self.map.Tiles()
        lz = -1
        last_str = None
        start = None
        maxid=0
        for tile in it:
            #print(str(tile))
            if lz != it.z:
                if start:
                    print('  -> Took {}'.format(getElapsed(start)))
                print(' * Consolidating level {}...'.format(it.z+1))
                start = clock()
                lz = it.z
            strt = tile.GetHash()  # str(tile)
            dbg = False
            #if strt == 'e18826df83665059358c177f43f6ac72':
            #    dbg=True
            if last_str == strt:
                #if dbg: print('Continuing: Same as last examined.') 
                continue
            if strt in examined:
                #if dbg: print('Continuing: Hash already examined.')
                last_str = strt
                continue
            # tile.ID = len(examined)
            examined += [strt]
            tid = self.GetTID(tile)
            if tid in self.typeMap:
                if hashMap.get(strt, None) == tid:
                    if dbg: print('Continuing: TID {} in typeMap, hashes match.'.format(tid))
                    continue
                tile.origID = ''
                tid = len(self.typeMap)
                while tid in self.typeMap:
                    tid+=1
                #print('{} assigned to new TID {}'.format(strt,tid))
            maxid=max(maxid,tid)

            #if tid == 0: print('<{},{},{}> {}: {}'.format(it.x, it.y, it.z, tid, str(tile)))
            self.typeMap[tid] = (strt,self.SerializeTile(tile))
            last_str = strt
            hashMap[strt]=tid
            
        ############################################################################
        ## HACK ALERT BECAUSE SOMETHING'S HORRIBLY WRONG AND I DON'T KNOW WHAT IT IS
        ############################################################################
        self.typeMap[0]=(self.typeMap[0][0],'(/turf/space,/area)')
        ### /hack
        
        idlen=len(self.ID2String(maxid))
        tmpfile = filename + '.tmp'
        print('Opening {} for write...'.format(tmpfile))
        print('idlen = {}'.format(idlen))
        print('"aaa" = {}'.format(self.typeMap[0][1]))
        start = clock()
        with open(tmpfile, 'w') as f:
            for tid in sorted(self.typeMap.keys()):
                stid=self.ID2String(tid, idlen)
                strt,serdata=self.typeMap[tid]
                f.write('"{}" = {}\n'.format(stid, serdata))
                self.type2TID[strt] = stid
            print(' Wrote types in {}...'.format(getElapsed(start)))
            lap = clock()
            for z in xrange(len(self.map.zLevels)):
                print(' Writing z={}...'.format(z))
                f.write('\n(1,1,{0}) = {{"\n'.format(z+1))
                zlevel = self.map.zLevels[z]
                for y in xrange(zlevel.height):
                    for x in xrange(zlevel.width):
                        tile = self.map.GetTileAt(x, y, z)
                        thash = tile.GetHash()
                        f.write(self.type2TID[thash])
                    f.write("\n")
                f.write('"}\n')
            print(' Wrote tiles in {}...'.format(getElapsed(lap)))
        if os.path.isfile(filename):
            os.remove(filename)
        os.rename(tmpfile, filename)
        print('-> {} in {}'.format(filename, getElapsed(start)))
        
