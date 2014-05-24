
import glob, os, sys
from setuptools import setup
from setuptools.command.install import install as _install

scripts = [
    'dmm',
    'dmi',
    'dmindent',
    'dmmrender',
    'dmmfix',
    
    'ss13_makeinhands'
]

def _post_install(dir):
    from subprocess import call
    print('dir={}'.format(dir))
    call([sys.executable, 'byondtools-postinstall.py'], cwd=dir)


class install(_install):
    def run(self):
        _install.run(self)
        # install_lib
        self.execute(_post_install, (self.install_scripts,),  msg="Running post install task")

options = {}
if sys.platform == "win32":
    scripts.append("byondtools-postinstall")
scripts = ['scripts/{}.py'.format(x) for x in scripts]
    
setup(name='BYONDTools',
    version='0.1.0',
    description='Tools and interfaces for interacting with the BYOND game engine.',
    url='http://github.com/N3X15/BYONDTools',
    author='N3X15',
    author_email='nexisentertainment@gmail.com',
    license='MIT',
    packages=['byond'],
    install_requires=[
        'Pillow'
    ],
    tests_require=['unittest-xml-reporting'],
    test_suite='tests',
    scripts=scripts,
    zip_safe=False,
    cmdclass={'install': install})