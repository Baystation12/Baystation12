#!/usr/bin/env python
"""
MIT License

Copyright (c) 2016 Pieter-Jan Briers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
import argparse
import hashlib
import os
import sys
import re
from distutils import spawn
try:
	import subprocess32 as subprocess
except ImportError:
	import subprocess

def main():
	parser = argparse.ArgumentParser()
	parser.add_argument('projectfile')
	parser.add_argument('outfile')
	namespace = parser.parse_args()

	if not os.access(namespace.projectfile, os.F_OK):
		print("Unable to access file, aborting.")
		return;
		
	print("Beginning global var generation...")

	tree = ""
	if namespace.projectfile[-4:] == ".txt":
		with open(namespace.projectfile, "r") as f:
			tree = f.read()

	else:
		tree = CompileFile(namespace.projectfile)
		with open("dump.txt", "wt") as f:
			f.write(tree)


	variables = ParseTree(tree)
	# print(variables)
	# Can't be bothered to fix the parser 100% so if something hates you just add it to this list to exclude it.
	ignores = []
	variables = [x for x in variables if re.match("^[a-z_$][a-z_$0-9]*$", x, re.IGNORECASE) != None and x not in ignores]
	# print(variables)

	variables.sort()
	code = GenCode(variables)
	
	with open(namespace.outfile, 'wb') as outfile:
		outfile.write(code.encode('utf-8'))
	
	hash = GenerateMD5(namespace.outfile)
	print("Global var generation complete. MD5 is: " + hash)
	
	
def GenerateMD5(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def CompileFile(filename):
	compiler_path = FindCompiler()

	return subprocess.check_output([compiler_path, "-code_tree", filename], universal_newlines=True)

def FindCompiler():
	compiler_path = None;

	if compiler_path:
		return compiler_path

	compiler_name = 'DreamMaker'

	if sys.platform == 'win32':
		compiler_name = 'dm'
	compiler_path = spawn.find_executable(compiler_name)
	if compiler_path == None and sys.platform == 'win32':
		# Attempt to look in %ProgramFiles% and %ProgramFiles(x86)% for BYOND.
		for path in (os.environ['ProgramFiles'], os.environ['ProgramFiles(x86)']):
			path = os.path.join(path, "BYOND", "bin", "dm.exe")

			if os.access(path, os.F_OK):
				compiler_path = path
				break

	if compiler_path == None:
		raise IOError("Unable to locate Dream Maker compiler binary. Please ensure that it is in your PATH.")

	return compiler_path

def GenCode(variables):
	out = "// THIS FILE IS AUTOMATICALLY CREATED BY tools/gen_globals.py\n/proc/readglobal(which)\n\tswitch(which)\n\t\t"

	for variable in variables:
		out += 'if("{0}")\n\t\t\treturn global.{0};\n\t\t'.format(variable)

	out += "\n/proc/writeglobal(which, newval)\n\tswitch(which)\n\t\t"

	for variable in variables:
		out += 'if("{0}")\n\t\t\tglobal.{0}=newval;\n\t\t'.format(variable)

	out += "\n/var/list/_all_globals=list(\n"
	for i, variable in enumerate(variables):
		out += '\t"{0}"'.format(variable)
		if i != len(variables) - 1:
			out += ",\n"

	out += ")\n"

	return out

def ParseTree(tree):
	variables = []
	lines = tree.split("\n")

	# Keep track of the current nodes we're in. Depth is the length of this.
	stack = []
	for index, line in enumerate(lines):
		# Root level
		node = line.split(" ", 1)[0].strip()
		
		indent = line.count("\t")

		# We're skipping some levels.
		if indent > len(stack):
			continue

		# print node, index

		# We dropped some levels, write the current var.
		if indent < len(stack):
			varname = stack.pop()
			if varname != "var":
				variables.append(varname)

				# Reset stack to where it needs to be.
				dropped_levels = len(stack) - indent
				for x in range(dropped_levels):
					stack.pop()

		# Hack to speed everything up by only doing vars.
		if len(stack) == 0:
			node = line.split(" ", 1)[0]
			if node == "var":
				stack.append(node)

			continue

		if len(stack) == 1 and node == "const":
			continue

		if node != "":
			stack.append(node)

	return variables

if __name__ == "__main__":
	main()
