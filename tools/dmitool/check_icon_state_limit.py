import argparse, re, sys
from os import path, walk
import dmitool # This import is why this script is here. If someone can import this file cleanly from [repo root]/test/ instead, feel free

opt = argparse.ArgumentParser()
opt.add_argument('dir', help='The directory to scan for *.dmi files with an excess number of icon states.')
args = opt.parse_args()

if(not path.isdir(args.dir)):
    print('Not a directory')
    sys.exit(1)
  
bad_dmi_files = []
  
# This section parses all *.dmi files in the given directory, recursively.
for root, subdirs, files in walk(args.dir):
    for filename in files:
        if filename.endswith('.dmi'):
            file_path = path.join(root, filename)
            dmi_info = dmitool.info(file_path)
            number_of_icon_states = len(dmi_info["states"])
            print("{0} - {1}".format(file_path, number_of_icon_states))
            if number_of_icon_states > 512:
                bad_dmi_files.append((file_path, number_of_icon_states))

if len(bad_dmi_files) > 0:
    for dmi_path, icon_states in bad_dmi_files:
        print("{0} had too many icon states. {1}/512.".format(dmi_path, icon_states))
    sys.exit(1)
