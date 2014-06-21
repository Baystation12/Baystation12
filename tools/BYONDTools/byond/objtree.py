'''
Superficially generate an object/property tree.
'''
import re, logging, os

try:
    import cPickle as pickle
except:
    import pickle
   
from .basetypes import Atom, Proc, BYONDValue, BYONDString, BYONDFileRef
from .utils import md5sum, get_stdlib

REGEX_TABS = re.compile('^(?P<tabs>[\t\s]*)')
REGEX_ATOMDEF = re.compile('^(?P<tabs>\t*)(?P<atom>[a-zA-Z0-9_/]+)\\{?\\s*$')
REGEX_ABSOLUTE_PROCDEF = re.compile('^(?P<tabs>\t*)(?P<atom>[a-zA-Z0-9_/]+)/(?P<proc>[a-zA-Z0-9_]+)\((?P<args>.*)\)\\{?\s*$')
REGEX_RELATIVE_PROCDEF = re.compile('^(?P<tabs>\t*)(?P<proc>[a-zA-Z0-9_]+)\((?P<args>.*)\)\\{?\\s*$')
REGEX_LINE_COMMENT = re.compile('//.*?$')

def debug(filename, line, path, message):
    print('{0}:{1}: {2} - {3}'.format(filename, line, '/'.join(path), message))
    
class OTRCache:
    # : Only used for obliterating outdated data.
    VERSION = [28, 4, 2014]
    
    def __init__(self, filename):
        self.filename = filename
        self.files = {}
        self.atoms = None
        self.handle = None

    def StartReading(self):
        if self.handle:
            self.handle.close()
        self.handle = None
        if os.path.isfile(self.filename):
            self.handle = open(self.filename, 'r')

    def StopReading(self):
        if self.handle is not None:
            self.handle.close()
        
    def CheckVersion(self):
        # print('READ VERSION')
        # Block 1: Version
        if pickle.load(self.handle) != self.VERSION:
            print('!!! Outdated OTR data, rebuilding.')
            return False
        return True
    
    def ReadFiles(self):
        # print('READ FILES')
        # Block 2: Files
        self.files = pickle.load(self.handle)
    
    def ReadAtoms(self):
        # print('READ ATOMS')
        return pickle.load(self.handle)
        
    def CheckFileHash(self, fn, md5):
        # print('{0}: {1}'.format(fn,md5))
        if fn not in self.files:
            print(' + {0}'.format(fn))
            return False
        if self.files[fn] != md5:
            print(' * {0}'.format(fn))
            return False
        return True
    
    def PruneFiles(self, file_list):
        for fn in self.files.keys():
            if fn not in file_list:
                self.files -= [fn]
                print(' - {0}'.format(fn))
        
    def SetFileMD5(self, fn, md5):
        self.files[fn] = md5
        
    def GetFiles(self):
        return self.files.keys()
        
    def Save(self, atoms):
        with open(self.filename, 'w') as f:
            pickle.dump(self.VERSION, f)
            pickle.dump(self.files, f)
            pickle.dump(atoms, f)

class ObjectTree:
    reserved_words = ('else', 'break', 'return', 'continue', 'spawn')  # , 'proc')
    stdlib_files = (
        'dm_std.dm',
        'atom_defaults.dm'
    )
    def __init__(self, **options):
        #: All atoms, in a list.
        self.Atoms = {}
        
        #: All atoms, in a tree-node structure.
        self.Tree = Atom('')
        
        #: Skip loading from .OTR?
        self.skip_otr = False
        
        self.LoadedStdLib = False
        self.cpath = []
        self.popLevels = []
        self.InProc = []
        self.pindent = 0  # Previous Indent
        self.ignoreLevel = []  # Block Comments
        self.ignoreStartIndent = -1
        self.debugOn = True
        self.ignoreDebugOn = False
        self.ignoreTokens = {
            '/*':'*/',
            '{"':'"}'
        }
        self.defines = {}
        self.defineMatchers = {}
        self.comments = []
        self.fileLayouts = {}
        self.LeavePreprocessorDirectives = options.get('preprocessor_directives', False)
        
        nit = self.ignoreTokens.copy()
        for _, stop in self.ignoreTokens.iteritems():
            nit[stop] = None
        self.ignoreTokens = nit
        
        self.defines['__OBJTREE'] = BYONDValue('1')
    
    def ProcessMultiString(self, filename, line, ignoreLevels, current_buffer):
        return '"{0}"'.format(current_buffer)
    
    def SplitPath(self, string):
        o = []
        buf = []
        inProc = False
        for chunk in string.split('/'):
            if not inProc: 
                if '(' in chunk and ')' not in chunk:
                    inProc = True
                    buf += [chunk]
                else:
                    o += [chunk]
            else:
                if ')' in chunk:
                    o += ['/'.join(buf + [chunk])]
                    inProc = False
                else:
                    buf += [chunk]
        return o
        
    def ProcessFilesFromDME(self, dmefile='baystation12.dme', ext='.dm', **kwargs):
        changed_files = 0
        rootdir = os.path.dirname(dmefile)
        projectfile = os.path.join(rootdir, os.path.basename(dmefile).replace('.dme', '.otr'))
        
        cache = OTRCache(projectfile)
        invalid = False
        if not self.skip_otr:
            if os.path.isfile(projectfile):
                print('--- Loading pickled object tree...')
                cache.StartReading()
                if cache.CheckVersion():
                    cache.ReadFiles()
                else:
                    invalid = True
            else:
                invalid = True
                
        ToRead = []
        if not self.LoadedStdLib and kwargs.get('load_stdlib', True):
            stdlib_dir = get_stdlib()
            for filename in self.stdlib_files:
                # self.ProcessFile(os.path.join(stdlib_dir, filename))
                ToRead += [os.path.join(stdlib_dir, filename)]
        with open(dmefile, 'r') as dmeh:
            for line in dmeh:
                if line.startswith('#include'):
                    inString = False
                    # escaped=False
                    filename = ''
                    for c in line:
                        """
                        if c == '\\' and not escaped:
                            escaped = True
                            continue
                        if escaped:
                            if
                            escaped = False
                            continue
                        """         
                        if c == '"':
                            inString = not inString
                            if not inString:
                                filepath = os.path.join(rootdir, filename)
                                if filepath.endswith(ext):
                                    ToRead += [filepath]
                                filename = ''
                            continue
                        else:
                            if inString:
                                filename += c
        
        for filepath in ToRead:
            md5 = md5sum(filepath)
            if invalid or not cache.CheckFileHash(filepath, md5):
                changed_files += 1
                cache.SetFileMD5(filepath, md5)
        if invalid or self.skip_otr or changed_files > 0:
            if invalid:
                print('--- Rebuilding object tree - Parsing DM files...'.format(changed_files))
            else:
                print('--- {0} changed files. Parsing DM files...'.format(changed_files))
            for f in ToRead:
                self.ProcessFile(f)
            print('--- Saving atoms...')
            cache.StopReading()
            cache.Save(self.Atoms)
            self.MakeTree()
        else:
            print('--- No changes detected, using pickled atoms...')
            self.Atoms = cache.ReadAtoms()
            cache.StopReading()
            self.MakeTree()
            
    def DetermineContext(self, filename, ln, line, numtabs, atom_prefix=[]):
        '''
        Spit out the full path of the atom we're currently in.
        
        Does NOT update internal positioning.  Think peek.
        '''
        if numtabs == 0:
            return None  # Global context
            
        elif numtabs > self.pindent:
            return '/'.join(self.cpath + atom_prefix)
            
        elif numtabs < self.pindent:
            cpath_copy = list(self.cpath)
            for _ in range(self.pindent - numtabs + 1):
                popsToDo = self.popLevels.pop()
                for _ in range(popsToDo):
                    cpath_copy.pop()
            cpath_copy += atom_prefix
            return '/'.join(cpath_copy)
            
        elif numtabs == self.pindent:
            cpath_copy = list(self.cpath)
            levelsToPop = self.popLevels.pop()
            for _ in range(levelsToPop):
                cpath_copy.pop()
            cpath_copy += atom_prefix
            return '/'.join(cpath_copy)
        
            
    def ProcessAtom(self, filename, ln, line, atom, atom_path, numtabs, procArgs=None):
        # Reserved words that show up on their own
        if atom in ObjectTree.reserved_words:
            return
        
        # Other things to ignore (false positives, comments)
        if atom.startswith('var/') or atom.startswith('//'):
            return
        
        # Things part of a string or list.
        if numtabs > 0 and atom.strip().startswith('/'):
            return

        if self.debugOn: print('{} > {}'.format(numtabs, line.rstrip()))
        
        if numtabs == 0:
            self.cpath = atom_path
            if len(self.cpath) == 0:
                self.cpath += ['']
            elif self.cpath[0] != '':
                self.cpath.insert(0, '')
            self.popLevels = [len(self.cpath)]
            if self.debugOn: debug(filename, ln, self.cpath, '0 - ' + repr(atom_path))
            
        elif numtabs > self.pindent:
            self.cpath += atom_path
            self.popLevels += [len(atom_path)]
            if self.debugOn: debug(filename, ln, self.cpath, '>')
            
        elif numtabs < self.pindent:
            if self.debugOn: print('({} - {})={}: {}'.format(self.pindent, numtabs, self.pindent - numtabs, repr(self.cpath)))
            for _ in range(self.pindent - numtabs + 1):
                popsToDo = self.popLevels.pop()
                if self.debugOn: print(' pop {} {}'.format(popsToDo, self.popLevels))
                for i in range(popsToDo):
                    self.cpath.pop()
                    if self.debugOn: print('  pop {}/{}: {}'.format(i + 1, popsToDo, repr(self.cpath)))
            self.cpath += atom_path
            self.popLevels += [len(atom_path)]
            if self.debugOn: debug(filename, ln, self.cpath, '<')
            
        elif numtabs == self.pindent:
            levelsToPop = self.popLevels.pop()
            for i in range(levelsToPop):
                self.cpath.pop()
            self.cpath += atom_path
            self.popLevels += [len(atom_path)]
            if self.debugOn: print('popLevels: ' + repr(self.popLevels))
            if self.debugOn: debug(filename, ln, self.cpath, '==')
            
        origpath = '/'.join(self.cpath)
        # print(npath)
        
        # definition?
        defs = []
        
        # Trim off /proc or /var, if needed.
        prep_path = list(self.cpath)
        
        for special in ['proc']:
            if special in prep_path:
                defs += [special]
                prep_path.remove(special)
        
        npath = '/'.join(prep_path)
        
        if npath not in self.Atoms:
            if procArgs is not None:
                assert npath.endswith(')')
                # if origpath != npath:
                #    print(origpath,proc_def)
                proc = Proc(npath, procArgs, filename, ln)
                proc.origpath = origpath
                proc.definition = 'proc' in defs
                self.Atoms[npath] = proc
            else:
                self.Atoms[npath] = Atom(npath, filename, ln)
            # if self.debugOn: print('Added ' + npath)
        self.pindent = numtabs
        return self.Atoms[npath]
    
    def AddCodeToProc(self, startIndent, code):
        if '\n' in code:
            for line in code.split('\n'):
                self.AddCodeToProc(startIndent, line)
        else:
            m = REGEX_TABS.match(code)
            if m is not None:
                numtabs = len(m.group('tabs'))
            i = max(1, numtabs - startIndent)
            # self.loadingProc.AddCode(i, '/* {0} */ {1}'.format(i,code.strip()))
            self.loadingProc.AddCode(i, code.rstrip())
            
    def finishComment(self, line, **args):
        self.comments += [self.comment]
        self.fileLayout += [('COMMENT', len(self.comments) - 1)]
        if self.ignoreDebugOn: print('finishComment({}): {}'.format(line, self.comment))
        if self.loadingProc is not None and (args.get('cleansed_line', '') == '' and not self.comment.strip().startswith('//')):
            self.AddCodeToProc(self.ignoreStartIndent, self.comment)
        self.comment = ''
        
    def handleOBToken(self, name, context, params):
        if context is not None:
            context = self.Atoms[context]
        name = 'ob_{0}'.format(name.lower())
        getattr(self, name)(context, *params)
        
    def ProcessFile(self, filename):
        self.cpath = []
        self.popLevels = []
        self.pindent = 0  # Previous Indent
        self.ignoreLevel = []
        self.debugOn = False
        self.ignoreDebugOn = False
        self.ignoreStartIndent = -1
        self.loadingProc = None
        self.comment = ''
        self.fileLayout = []
        self.lineBeforePreprocessing = ''
        self.current_filename = filename
        with open(filename, 'r') as f:
            ln = 0
            ignoreLevel = []
            
            for line in f:
                ln += 1

                skipNextChar = False
                nl = ''
                    
                line = line.rstrip()
                self.lineBeforePreprocessing = line
                line_len = len(line)
                for i in xrange(line_len):
                    c = line[i]
                    nc = ''
                    if line_len > i + 1:
                        nc = line[i + 1]
                    tok = c + nc
                    # print(tok)
                    if skipNextChar:
                        if self.ignoreDebugOn: print('Skipping {}.'.format(repr(tok)))
                        skipNextChar = False
                        # self.comment += c
                        if self.ignoreDebugOn: print('self.comment = {}.'.format(repr(self.comment)))
                        continue
                    if tok == '//':
                        # if self.ignoreDebugOn: debug(filename,ln,self.cpath,'{} ({})'.format(tok,len(ignoreLevel)))
                        if len(ignoreLevel) == 0:
                            self.comment = line[i:]
                            # if self.ignoreDebugOn: print('self.comment = {}.'.format(repr(self.comment)))
                            # print('Found '+self.comment)
                            self.finishComment('243', cleaned_line=nl)
                            break
                    if tok in self.ignoreTokens:
                        pc = ''
                        if i > 0:
                            pc = line[i - 1]
                        if tok == '{"' and pc == '"':
                            self.comment += c
                            continue
                        # if self.ignoreDebugOn: print(repr(self.ignoreTokens[tok]))
                        stop = self.ignoreTokens[tok]
                        if stop == None:  # End comment
                            if len(ignoreLevel) > 0:
                                if ignoreLevel[-1] == tok:
                                    skipNextChar = True
                                    self.comment += tok
                                    ignoreLevel.pop()
                                    if len(ignoreLevel) == 0:
                                        self.finishComment('261')
                                    continue
                                else:
                                    self.comment += c
                                    continue
                        else:  # Start comment
                            skipNextChar = True
                            ignoreLevel += [stop]
                            self.comment = tok
                            continue
                        if self.ignoreDebugOn: debug(filename, ln, self.cpath, '{} ({})'.format(tok, len(ignoreLevel)))
                    if len(ignoreLevel) == 0:
                        nl += c
                    else:
                        self.comment += c
                if line != nl:
                    if self.ignoreDebugOn: print('IN : ' + line)
                    line = nl
                    if self.ignoreDebugOn: print('OUT: ' + line)
                    if self.ignoreDebugOn: print('self.comment = {}.'.format(repr(self.comment)))
                    
                if len(ignoreLevel) > 0:
                    self.comment += "\n"
                    continue
                
                line = REGEX_LINE_COMMENT.sub('', line)
                
                if line.strip() == '':
                    if self.loadingProc is not None:
                        self.loadingProc.AddBlankLine()
                    continue
                
                # Preprocessing defines.
                if line.strip().startswith("#"):
                    if line.endswith('\\'): continue
                    tokenChunks = line.split('#')
                    tokenChunks = tokenChunks[1].split()
                    directive = tokenChunks[0]
                    if directive == 'define':
                        # #define SOMETHING Value
                        defineChunks = line.split(None, 3)
                        if len(defineChunks) == 2:
                            defineChunks += [1]
                        elif len(defineChunks) == 3:
                            defineChunks[2] = self.PreprocessLine(defineChunks[2])
                        # print(repr(defineChunks))
                        try:
                            if '.' in defineChunks[2]:
                                self.defines[defineChunks[1]] = BYONDValue(float(defineChunks[2]), filename, ln)
                            else:
                                self.defines[defineChunks[1]] = BYONDValue(int(defineChunks[2]), filename, ln)
                        except:
                            self.defines[defineChunks[1]] = BYONDString(defineChunks[2], filename, ln)
                        self.fileLayout += [('DEFINE', defineChunks[1], defineChunks[2])]
                    elif directive == 'undef':
                        undefChunks = line.split(' ', 2)
                        if undefChunks[1] in self.defines:
                            del self.defines[undefChunks[1]]
                        self.fileLayout += [('UNDEF', undefChunks[1])]
                    
                    # OpenBYOND tokens.
                    elif directive.startswith('__OB_'):
                        numtabs = 0
                        m = REGEX_TABS.match(line)
                        if m is not None:
                            numtabs = len(m.group('tabs'))
                        atom = self.DetermineContext(filename, ln, line, numtabs)
                        # if atom is None: continue
                        # print('OBTOK {0}'.format(repr(tokenChunks)))
                        self.handleOBToken(tokenChunks[0].replace('__OB_', ''), atom, tokenChunks[1:])
                        # self.fileLayout += [('OBTOK', atom.path)]
                        continue
                    else:
                        chunks = line.split(' ')
                        self.fileLayout += [('PP_TOKEN', line)]
                        print('BUG: Unhandled preprocessor directive #{} in {}:{}'.format(directive, filename, ln))
                    continue
                
                # Preprocessing
                line = self.PreprocessLine(line)
                
                m = REGEX_TABS.match(self.lineBeforePreprocessing)
                if m is not None:
                    numtabs = len(m.group('tabs'))
                    if self.ignoreStartIndent > -1 and self.ignoreStartIndent < numtabs:
                        if self.loadingProc is not None:
                            # self.loadingProc.AddCode(numtabs - self.ignoreStartIndent, self.lineBeforePreprocessing.strip())
                            self.AddCodeToProc(self.ignoreStartIndent, self.lineBeforePreprocessing)
                        if self.debugOn: print('TABS: {} ? {} - {}: {}'.format(numtabs, self.ignoreStartIndent, self.loadingProc, line))
                        continue
                    else:
                        if self.debugOn and self.ignoreStartIndent > -1: print('BREAK ({} -> {}): {}'.format(self.ignoreStartIndent, numtabs, line))
                        self.ignoreStartIndent = -1
                        self.loadingProc = None
                else:
                    if self.debugOn and self.ignoreStartIndent > -1: print('BREAK ' + line)
                    self.ignoreStartIndent = -1
                    self.loadingProc = None
                
                if not line.strip().startswith('var/'):
                    m = REGEX_ATOMDEF.match(line)
                    if m is not None:
                        numtabs = len(m.group('tabs'))
                        atom = m.group('atom')
                        atom_path = self.SplitPath(atom)
                        atom = self.ProcessAtom(filename, ln, line, atom, atom_path, numtabs)
                        if atom is None: continue
                        self.fileLayout += [('ATOMDEF', atom.path)]
                        continue
                    
                    m = REGEX_ABSOLUTE_PROCDEF.match(line)
                    if m is not None:
                        numtabs = len(m.group('tabs'))
                        atom = '{0}/{1}({2})'.format(m.group('atom'), m.group("proc"), m.group('args')) 
                        atom_path = self.SplitPath(atom)
                        # print('PROCESSING ABS PROC AT INDENT > ' + str(numtabs) + " " + atom+" -> "+repr(atom_path))
                        proc = self.ProcessAtom(filename, ln, line, atom, atom_path, numtabs, m.group('args').split(','))
                        if proc is None: continue
                        self.ignoreStartIndent = numtabs
                        self.loadingProc = proc
                        self.fileLayout += [('PROCDEF', proc.path)]
                        continue
                    
                    m = REGEX_RELATIVE_PROCDEF.match(line)
                    if m is not None:
                        numtabs = len(m.group('tabs'))
                        atom = '{}({})'.format(m.group("proc"), m.group('args')) 
                        atom_path = self.SplitPath(atom)
                        # print('IGNORING RELATIVE PROC AT INDENT > ' + str(numtabs) + " " + line)
                        proc = self.ProcessAtom(filename, ln, line, atom, atom_path, numtabs, m.group('args').split(','))
                        if proc is None: continue
                        self.ignoreStartIndent = numtabs
                        self.loadingProc = proc
                        self.fileLayout += [('PROCDEF', proc.path)]
                        continue
                
                path = '/'.join(self.cpath)
                # if len(self.cpath) > 0 and 'proc' in self.cpath:
                #    continue
                # if 'proc' in self.cpath:
                #    continue
                if '=' in line or line.strip().startswith('var/'):
                    if path not in self.Atoms:
                        self.Atoms[path] = Atom(path)
                    name, prop = self.consumeVariable(line, filename, ln)
                    self.Atoms[path].properties[name] = prop
                    self.fileLayout += [('VAR', path, name)]
        self.fileLayouts[filename] = self.fileLayout
        
    def consumeVariable(self, line, filename, ln):
        declaration = False
        value = None
        size = None
        
        decl = ''
        if self.LeavePreprocessorDirectives:
            line = decl = self.lineBeforePreprocessing.strip()
        else:
            decl = line.strip()
        if '[' in line:
            line_split, arr_decl = line.split('[', 1)
            str_size = arr_decl[:arr_decl.index(']')]
            size = -1
            if str_size != '':
                try:
                    size = int(str_size)
                except ValueError:
                    pass
            # print(repr({'size':size,'line':line_split}))
            line = line_split
            
        if '=' in line:
            decl, value = line.split('=', 1)
            decl = decl.strip()
            value = value.strip()
        else:
            decl = line.strip()
            value = None
        # print(repr({'decl':decl,'value':value}))
            
        # (var)(/global|const|tmp)(/type/fragment)name
        if decl.startswith('var/'):
            declaration = True
            decl = decl[4:]
        pathchunks = decl.split('/')
        name = pathchunks[-1]
        special = None
        typepath = '/'
        if declaration:
            if pathchunks[0] in ('tmp', 'global', 'const'):
                special = pathchunks[0]
                pathchunks = pathchunks[1:]
            if 'list' not in pathchunks and size is not None:
                pathchunks = ['list'] + pathchunks
            typepath = '/' + '/'.join(pathchunks[:-1])
            
        kwargs = {
            'declaration':declaration,
            'special':special,
            'size':size
        }
        if typepath != '/':
            return (name, BYONDValue(value, filename, ln, typepath, **kwargs))
        elif value and value[0] == '"':
            return (name, BYONDString(value[1:-1], filename, ln, **kwargs))
        elif value and value[0] == "'":
            return (name, BYONDFileRef(value[1:-1], filename, ln, **kwargs))
        elif value and '.' in value:
            try:
                return (name, BYONDValue(float(value), filename, ln, typepath, **kwargs))
            except ValueError:
                pass
        return (name, BYONDValue(value, filename, ln, typepath, **kwargs))
        
    def MakeTree(self):
        print('Generating Tree...')
        self.Tree = Atom('/')
        with open('objtree.txt', 'w') as f:
            for key in sorted(self.Atoms):
                f.write("{0}\n".format(key))
                atom = self.Atoms[key]
                cpath = []
                cNode = self.Tree
                fullpath = self.SplitPath(atom.path)
                truncatedPath = fullpath[1:]
                for path_item in truncatedPath:
                    cpath += [path_item]
                    cpath_str = '/'.join([''] + cpath)
                    # if path_item == 'var':
                    #    if path_item not in cNode.properties:
                    #        cNode.properties[fullpath[-1]]='???'
                    if path_item not in cNode.children:
                        if cpath_str in self.Atoms:
                            cNode.children[path_item] = self.Atoms[cpath_str]
                        else:
                            if '(' in path_item:
                                cNode.children[path_item] = Proc('/'.join([''] + cpath), [])
                            else:
                                cNode.children[path_item] = Atom('/'.join([''] + cpath),atom.filename,atom.line)
                        cNode.children[path_item].parent = cNode
                        parent_type = cNode.children[path_item].getProperty('parent_type')
                        if parent_type is not None:
                            print(' - Parent of {0} forced to be {1}'.format(cNode.children[path_item].path, repr(parent_type)))
                            cNode.children[path_item].parent = self.Atoms[parent_type]
                    cNode = cNode.children[path_item]
        self.Tree.InheritProperties()
        print('Processed {0} atoms.'.format(len(self.Atoms)))
        # self.Atoms = {}
        
    def GetAtom(self, path):
        if path in self.Atoms:
            return self.Atoms[path]
        
        cpath = []
        cNode = self.Tree
        fullpath = path.split('/')
        truncatedPath = fullpath[1:]
        for path_item in truncatedPath:
            cpath += [path_item]
            if path_item not in cNode.children:
                print('Unable to find {0} (lost at {1})'.format(path, cNode.path))
                print(repr(cNode.children.keys()))
                return None
            cNode = cNode.children[path_item]
        # print('Found {0}!'.format(path))
        self.Atoms[path] = cNode
        return cNode
        

    def PreprocessLine(self, line):
        for key, define in self.defines.items():
            if key in line:
                if key not in self.defineMatchers:
                    self.defineMatchers[key] = re.compile(r'\b' + key + r'\b')
                newline = self.defineMatchers[key].sub(str(define.value), line)
                if newline != line:
                    '''
                    if filename.endswith('pipes.dm'):
                        print('OLD: {}'.format(line))
                        print('PPD: {}'.format(newline))
                    '''
                    line = newline
        return line
