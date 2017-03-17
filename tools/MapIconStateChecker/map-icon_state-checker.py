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
from os import sep, path, walk
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

issues_per_file = defaultdict(list)

def icon_state_exception(subtype):
	for type, exception in icon_state_exceptions.iteritems():
		if subtype.startswith(type):
			return exception
	return no_exception
	
def validate_line(line):
	invalid_icon_states = Set()
	for type, vars in type_and_vars.findall(line):
		exception = icon_state_exception(type)
		for icon_state in icon_state_value.findall(vars):
			if not exception.match(icon_state):
				invalid_icon_states.add((type, icon_state))
	return invalid_icon_states

# This section parses all *.dmm files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
    for filename in files:
        if filename.endswith('.dmm'):
            file_path = path.join(root, filename)
            with open(file_path, 'r') as file:
				for line_number, line in enumerate(file, 1):
					if end_of_map.match(line):
						break
					invalid_states = validate_line(line)
					for type, icon_state in invalid_states:
						issues_per_file[file_path].append((line_number, type, icon_state))

for file_path, issues in issues_per_file.iteritems():
	print(file_path)
	for line_number, type, icon_state in issues:
		print("\t{0}: {1} - {2}".format(line_number, type, icon_state))

if len(issues_per_file) > 0:
	print('The listed files above contain icon_state edits at the listed lines.')
	sys.exit(1)
