import argparse, re, sys
from os import sep, path, walk

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for *.dm files with non-matching spans')
args = opt.parse_args()

if(not path.isdir(args.dir)):
	print('Not a directory')
	sys.exit(1)

exceptions = [('code/modules/hydroponics/grown.dm', 'desc = "A"')]
end_desc_exceptions = ['."', '?"', '!"', ')"', ']"', '.</I>"', '!</I>"', '.</i>"', '?</i>"', '!\'</i>"', '.\'</i>"', '~"', '.</b>"', '"', '\"']
found_bad_descriptions = False

for index, exception in enumerate(exceptions, 0):
	exceptions[index] = (exception[0].replace('/', sep), exception[1])

# This section parses all *.dm files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
	for filename in files:
		if filename.endswith('.dm'):
			file_path = path.join(root, filename)
			with open(file_path, 'r', encoding="latin-1") as file:
				print_lines = False
				for line_number, line in enumerate(file, 1):
					if line.startswith('/obj/'):
						print_lines = True
						continue
					elif line.startswith('/'):
						print_lines = False
						continue
					if not print_lines:
						continue
					line = line.strip()
					if not line.startswith('desc = "'):
						continue
					last_comment_index = line.rfind('//')
					if last_comment_index >= 0:
						line = line[0:last_comment_index].strip()
					if line == 'desc = ""':
						continue
					if line.endswith('"'):
						print_line = True
						for end_desc_exception in end_desc_exceptions:
							if line.endswith(end_desc_exception):
								print_line = False
								break
						for exception in exceptions:
							if file_path.endswith(exception[0]) and line == exception[1]:
								print_line = False
								break
						if not print_line:
							continue
						print(file_path, ' ', line, ' ', line_number)
						found_bad_descriptions = True

if found_bad_descriptions:
	sys.exit(1)
