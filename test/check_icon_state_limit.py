import argparse, re, sys
from os import path, walk
from PIL import Image

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for *.dmi files with an excess number of icon states.')
args = opt.parse_args()

STATE_PATTERN = r'^state\s*='

def get_states_count(path):
    try:
        im = Image.open(path)
        return len(re.findall(STATE_PATTERN, im.info["Description"], re.MULTILINE))
    except (Image.UnidentifiedImageError):
        print("{0} is not a valid image".format(path))
        exit(1)

if(not path.isdir(args.dir)):
    print('Not a directory')
    sys.exit(1)

bad_dmi_files = []

# This section parses all *.dmi files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
    for filename in files:
        if filename.endswith('.dmi'):
            file_path = path.join(root, filename)
            number_of_icon_states = get_states_count(file_path)
            if number_of_icon_states > 512:
                bad_dmi_files.append((file_path, number_of_icon_states))

if len(bad_dmi_files) > 0:
    for dmi_path, icon_states in bad_dmi_files:
        print("{0} had too many icon states. {1}/512.".format(dmi_path, icon_states))
    sys.exit(1)
