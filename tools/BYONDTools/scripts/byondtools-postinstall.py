#------------------------------------------------------------------------------
# Originally cxfreeze-postinstall
#   Script run after installation on Windows to fix up the Python location in
# the script as well as create batch files.
#------------------------------------------------------------------------------

import distutils.sysconfig
import glob
import os

vars = distutils.sysconfig.get_config_vars()
prefix = vars["prefix"]
python = os.path.join(prefix, "python.exe")
scriptDir = os.path.join(prefix, "Scripts")

# Keep in-sync with setup.py.
scripts = [
    'dmm',
    'dmi',
    'dmindent',
    'dmmrender',
    'dmmfix',
    
    'ss13_makeinhands'
]
for fileName in glob.glob(os.path.join(scriptDir, "*.py")):
    # skip already created batch files if they exist
    name, ext = os.path.splitext(os.path.basename(fileName))
    if name not in scripts:
        continue

    print('Running post-install for {}.'.format(name))
    # copy the file with the first line replaced with the correct python
    fullName = os.path.join(scriptDir, fileName)
    strippedName = os.path.join(scriptDir, name)
    lines = open(fullName).readlines()
    startidx=1
    if not lines[0].strip().startswith('#!'):
        print('WARNING: {} does not have a shebang.'.format(lines[0]))
        startidx=0
    outFile = open(fullName, "w")
    outFile.write("#!%s\n" % python)
    outFile.writelines(lines[startidx:])
    outFile.close()

    # create the batch file
    batchFileName = strippedName + ".bat"
    command = "%s %s %%*" % (python, fullName)
    open(batchFileName, "w").write("@echo off\n\n%s" % command)

