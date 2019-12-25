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
from collections import defaultdict
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
# The values of this dictionary is a another dictionary with the key/value pair: tag/list of unmatched lines
mismatches_by_file = { }

# Loops over all defined tag tuples and returns a dictionary with the key/value pair: tag/mismatch_count (positive means excess of opening tag, negative means excess of closing tags)
def get_tag_matches(line):
	mismatch_count_by_tag = { }
	for tag_tuple in tag_tuples:
		mismatch_count = 0
		mismatch_count += len(tag_tuple[1].findall(line))
		mismatch_count -= len(tag_tuple[2].findall(line))
		if mismatch_count != 0:
			mismatch_count_by_tag[tag_tuple[0]] = mismatch_count
	return mismatch_count_by_tag

# Support def that simply checks if a given dictionary in the format tag/list of unmatched lines has mismatch entries.
def has_mismatch(match_list):
	for tag, list_of_mismatched_lines in match_list.items():
		if(len(list_of_mismatched_lines) > 0):
			return 1
	return 0

def arrange_mismatches(mismatches_by_tag, mismatch_line, mismatch_counts):
	for tag, mismatch_count in mismatch_counts.items():
		stack_of_existing_mismatches = mismatches_by_tag[tag]
		for i in range(0, abs(mismatch_count)):
			if len(stack_of_existing_mismatches) == 0:
				if(mismatch_count > 0):
					stack_of_existing_mismatches.append(mismatch_line)
				else:
					stack_of_existing_mismatches.append(-mismatch_line)
			else:
				if stack_of_existing_mismatches[0] > 0:
					if mismatch_count > 0:
						stack_of_existing_mismatches.append(mismatch_line)
					else:
						stack_of_existing_mismatches.pop()
				else:
					if mismatch_count < 0:
						stack_of_existing_mismatches.append(-mismatch_line)
					else:
						stack_of_existing_mismatches.pop()


# This section parses all *.dm files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
	for filename in files:
		if filename.endswith('.dm'):
			file_path = path.join(root, filename)
			with open(file_path, 'r', encoding="latin-1") as file:
				mismatches_by_file[file_path] = defaultdict(list)
				for line_number, line in enumerate(file, 1):
					# Then for each line in the file, conduct the tuple open/close matching.
					mismatches_by_tag = get_tag_matches(line)
					arrange_mismatches(mismatches_by_file[file_path], line_number, mismatches_by_tag)

# Pretty printing section.
# Loops over all matches and checks if there is a mismatch of tags.
# If so, then and only then is the corresponding file path printed along with the number of unmatched open/close tags.
total_mismatches = 0
for file, mismatches_by_tag in mismatches_by_file.items():
	if has_mismatch(mismatches_by_tag):
		print(file)
		for tag, mismatch_list in mismatches_by_tag.items():
			# A positive number means an excess of opening tag, a negative number means an excess of closing tags.
			total_mismatches += len(mismatch_list)
			if len(mismatch_list) > 0:
				if mismatch_list[0] > 0:
					print('\t{0} - Excess of {1} opening tag(s)'.format(tag, len(mismatch_list)))
				elif mismatch_list[0] < 0:
					print('\t{0} - Excess of {1} closing tag(s)'.format(tag, len(mismatch_list)))
				for mismatch_line in sorted(set(mismatch_list)):
					print('\t\tLine {0}'.format(abs(mismatch_line)))

# Simply prints the total number of mismatches found and if so returns 1 to, for example, fail Travis builds.
if(total_mismatches == 0):
	print('No mismatches found.')
else:
	print('')
	print('Total number of mismatches: {0}'.format(total_mismatches))
	sys.exit(1)
