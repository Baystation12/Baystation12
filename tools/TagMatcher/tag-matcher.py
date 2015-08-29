import argparse, re, sys
from os import path, walk

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for files with non-matching spans')

args = opt.parse_args()

if(not path.isdir(args.dir)):
    print('Not a directory')
    sys.exit(1)

pair_of_tags = [('<span(.*?)>','</span>')]
mismatches = { }

for root, subdirs, files in walk(args.dir):
    for filename in files:
        if filename.endswith('.dm'):
            open_match = 0
            close_match = 0
            file_path = path.join(root, filename)
            with open(file_path, 'r') as f:
                open_span = re.compile(pair_of_tags[0][0], re.IGNORECASE)
                close_span = re.compile(pair_of_tags[0][1], re.IGNORECASE)
                for x in f:
                    open_match += len(open_span.findall(x))
                    close_match += len(close_span.findall(x))
                        
                if open_match != close_match:
                    if not pair_of_tags[0][0] in mismatches.keys():
                        mismatches[pair_of_tags[0][0]] = []
                    mismatches[pair_of_tags[0][0]].append('{0} - {1}/{2}'.format(file_path, open_match, close_match))

for mismatch_key in mismatches.keys():
    print(mismatch_key)
    for mismatch_value in mismatches[mismatch_key]:
        print('\t{0}').format(mismatch_value)
        
if len(mismatches.keys()) > 0:
    sys.exit(1)
