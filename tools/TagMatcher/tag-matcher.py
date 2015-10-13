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
import argparse, re, sys
from os import path, walk

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for *.dm files with non-matching spans')
args = opt.parse_args()

if(not path.isdir(args.dir)):
    print('Not a directory')
    sys.exit(1)

# These tuples are expected to be ordered as:
# A unique human readable name (henceforth referred to as tuple name), a regex pattern matching an opening tag, a regex pattern matching a closing tag
tag_tuples = [	('<span>', re.compile('<span(.*?)>', re.IGNORECASE), re.compile('</span>', re.IGNORECASE)),
				('<font>', re.compile('<font(.*?)>', re.IGNORECASE), re.compile('</font>', re.IGNORECASE)),
				('<center>', re.compile('<center>', re.IGNORECASE), re.compile('</center>', re.IGNORECASE)),
				('<b>', re.compile('<b>', re.IGNORECASE), re.compile('</b>', re.IGNORECASE)),
				('<i>', re.compile('<i>', re.IGNORECASE), re.compile('</i>', re.IGNORECASE))]

# The keys of this dictionary will be the file path of each parsed *.dm file
# The values of this dictionary will be in the format provided by populate_match_list().
matches = { }

# Support def for setting up a dictionary, populating it with all defined tuple names as key with each being assigned the value 0.
# One such dictionary is created for each parsed file.
def populate_match_list():
	match_list = { }
	for tag_tuple in tag_tuples:
		match_list[tag_tuple[0]] = 0
	return match_list

# This def shall be provided by a dictionary in the format given by populate_match_list() and a line of text.
# It loops over all defined tag tuples, adding the number of open tags found and subtracting the number of close tag found to the corresponding tuple name in the match list.
# This def is currently run with the same match_list for a given file and for all lines of that file.
def get_tag_matches(match_list, line):
	for tag_tuple in tag_tuples:
		match_list[tag_tuple[0]] += len(tag_tuple[1].findall(line))
		match_list[tag_tuple[0]] -= len(tag_tuple[2].findall(line))
	return 

# Support def that simply checks if a given dictionary in the format given by populate_match_list() contains any value that is non-zero.
# That is, a tag which had a non-equal amount of open/closing tags.
def has_mismatch(match_list):
	for tag, match_number in match_list.iteritems():
		if(match_number != 0):
			return 1
	return 0

# This section parses all *.dm files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
    for filename in files:
        if filename.endswith('.dm'):
            file_path = path.join(root, filename)
            with open(file_path, 'r') as f:
				# For each file, generate the match dictionary.
				matches[file_path] = populate_match_list()
				for x in f:
					# Then for each line in the file, conduct the tuple open/close matching.
					get_tag_matches(matches[file_path], x)

# Pretty printing section.
# Loops over all matches and checks if there is a mismatch of tags.
# If so, then and only then is the corresponding file path printed along with the number of unmatched open/close tags.
total_mismatch = 0
for file, match_list in matches.iteritems():
	if(has_mismatch(match_list)):
		print(file)
		for tag, match_number in match_list.iteritems():
			# A positive number means an excess of opening tag, a negative number means an excess of closing tags.
			if(match_number > 0):
				total_mismatch += match_number
				print('\t{0} - Excess of {1} opening tag(s)'.format(tag, match_number))
			elif (match_number < 0):
				total_mismatch -= match_number
				print('\t{0} - Excess of {1} closing tag(s)'.format(tag, -match_number))

# Simply prints the total number of mismatches found and if so returns 1 to, for example, fail Travis builds.				
if(total_mismatch == 0):
	print('No mismatches found.')
else:	
	print('')
	print('Total number of mismatches: {0}'.format(total_mismatch))
	sys.exit(1)
