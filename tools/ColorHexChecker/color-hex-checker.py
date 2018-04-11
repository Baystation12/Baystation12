import argparse, re, sys
from os import sep, path, walk

color_hex_matcher = re.compile('\"#[\dA-F]{6}\"', re.IGNORECASE)

def get_bad_hexes_in_line(line):
	bad_hexes = []
	for matched_hex in color_hex_matcher.findall(line):
		if any(x.isupper() for x in matched_hex):
			bad_hexes.append(matched_hex)
	return bad_hexes

def get_bad_hex_lines_in_file(file):
	bad_lines = {}
	for line_number, line in enumerate(file, 1):
		bad_hexes = get_bad_hexes_in_line(line)
		if len(bad_hexes):
			bad_lines[line_number] = bad_hexes
	return bad_lines

def print_bad_hexes(bad_hexes_by_path):
	for path, bad_hexes_by_line in bad_hexes_by_path.items():
		print('Path: {0}'.format(path))
		for line, bad_hexes in bad_hexes_by_line.items():
			print('\tLine: {0}'.format(line))
			for bad_hex in bad_hexes:
				print('\t\t{0}'.format(bad_hex))
	
def main():
	opt = argparse.ArgumentParser()
	opt.add_argument('dir', help='The directory to recursively scan for *.dm and *.dmm files with invalid color hexes')
	args = opt.parse_args()

	if(not path.isdir(args.dir)):
		print('Not a directory')
		sys.exit(1)

	bad_hexes_by_path = { }
	# This section parses all *.dm and *.dmm files in the given directory, recursively.
	for root, subdirs, files in walk(args.dir):
		for filename in files:
			if filename.endswith('.dm') or filename.endswith('.dmm'):
				file_path = path.join(root, filename)
				with open(file_path, 'r', encoding = 'latin-1') as file:
					bad_hex_by_line = get_bad_hex_lines_in_file(file)
					if len(bad_hex_by_line) > 0:
						bad_hexes_by_path[file_path] = bad_hex_by_line

	print_bad_hexes(bad_hexes_by_path)
	if len(bad_hexes_by_path) > 0:
		sys.exit(1)

if __name__ == "__main__":
	main()
