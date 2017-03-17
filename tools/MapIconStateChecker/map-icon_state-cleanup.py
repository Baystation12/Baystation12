'''
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
'''
import argparse
import re
import sys
from collections import defaultdict
from os import sep, path, remove, rename, walk
from sets import Set

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for *.dmm files with icon_state edits')
args = opt.parse_args()

if(not path.isdir(args.dir)):
    print('Not a directory')
    sys.exit(1)

no_exception = re.compile('^$')
icon_state_exceptions = {
	'/obj/structure/cable'             : re.compile('^[\d]{1,2}-[\d]{1,2}$'),
	'/obj/machinery/atmospherics/pipe' : re.compile('^map$')
}
end_of_map = re.compile('^\((\d*),(\d*),(\d*)\) = {"$')
type_and_vars = re.compile('(/[^,]+?){(.+?)\}')
icon_state_value = re.compile('icon_state = "(.+?)"')

tag_replacements = {
	re.compile('\{tag = (.+?)\; ')     : '{',
	re.compile('\; tag = ([^\;]+?)\}') :  '}'
}

icon_state_replacements = {
	re.compile('/turf/space{icon_state = "black"}') : '/turf/space/black',
}

def icon_state_exception(subtype):
	for type, exception in icon_state_exceptions.iteritems():
		if subtype.startswith(type):
			return exception
	return no_exception
	
def remove_tags(line):
	for regex, repacement in tag_replacements.iteritems():
		line = regex.sub(repacement, line)
	return line

def replace_icon_states(line):
	for regex, repacement in icon_state_replacements.iteritems():
		line = regex.sub(repacement, line)
	return line

def adjust_line(line):
	line = remove_tags(line)
	line = replace_icon_states(line)
	#for type, vars in type_and_vars.findall(line):
	#	exception = icon_state_exception(type)
	#	for icon_state in icon_state_value.findall(vars):
	#		if not exception.match(icon_state):
	#			invalid_icon_states.add((type, icon_state))
	return line

# This section parses all *.dmm files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
    for filename in files:
        if filename.endswith('.dmm'):
            read_file_path = path.join(root, filename)
            write_file_path = path.join(root, filename + '.tmp')
            with open(read_file_path, 'rb') as open_file:
                with open(write_file_path, 'wb') as write_file:
                    end_of_map_reached = False
                    for line_number, line in enumerate(open_file, 1):
                        if not end_of_map_reached and end_of_map.match(line):
                            end_of_map_reached = True
                        if end_of_map_reached:
                            write_file.write(line)
                        else:
                            write_file.write(adjust_line(line))
            remove(read_file_path)
            rename(write_file_path, read_file_path)
