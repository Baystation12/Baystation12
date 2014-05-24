#!/usr/bin/env python
import os, argparse, logging
from byond.objtree import ObjectTree
from byond.basetypes import Atom
from byond.map import Map, MapRenderFlags
"""
Usage:
    $ python dmmrender.py path/to/your/project.dme path/to/your/map.dmm

generateMap.py - Creates an image of a DMM map.

Copyright 2013 Rob "N3X15" Nelson <nexis@7chan.org>

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

"""
                
def renderMap(args):
    outfile = args.map + '.{z}.png'
    if args.area:
        kwargs['area'] = args.area
        outfile = args.area[0].replace('/', '_') + '.png'
    if args.render_types:
        print(repr(args.render_types))
        kwargs['render_types'] = args.render_types
    if args.outfile:
        outfile = args.outfile
        if os.path.isdir(outfile):
            title, _ = os.path.splitext(os.path.basename(args.map))
            outfile = os.path.join(outfile, '{}.{{z}}.png'.format(title))
    dmm.generateImage(outfile, os.path.dirname(args.project), renderflags, **kwargs)

logging.basicConfig(
    format='%(asctime)s [%(levelname)-8s]: %(message)s',
    datefmt='%m/%d/%Y %I:%M:%S %p',
    level=logging.INFO  # ,
    # filename='logs/main.log',
    # filemode='w'
    )
opt = argparse.ArgumentParser()
opt.add_argument('project', metavar="project.dme")
opt.add_argument('map', metavar="map.dmm")
opt.add_argument('--render-stars', dest='render_stars', default=False, action='store_true', help="Render space.  Normally off to prevent ballooning the image size.")
opt.add_argument('--render-areas', dest='render_areas', default=False, action='store_true', help="Render area overlays.")
opt.add_argument('--render-only', dest='render_types', action='append', help="Render ONLY these types.  Can be used multiple times to specify more types.")
opt.add_argument('--area', dest='area', type=list, nargs='*', default=None, help="Specify an area to restrict rendering to.")
opt.add_argument('-O', '--out', dest='outfile', type=str, default=None, help="What to name the file ({z} will be replaced with z-level)")
opt.add_argument('--area-list', dest='areas', type=str, default=None, help="A file with area_file.png = /area/path on each line")
args = opt.parse_args()
if os.path.isfile(args.project):
    tree = ObjectTree()
    tree.ProcessFilesFromDME(args.project)
    dmm = Map(tree)
    dmm.readMap(args.map)
    renderflags = 0
    if args.render_stars:
        renderflags |= MapRenderFlags.RENDER_STARS
    if args.render_areas:
        renderflags |= MapRenderFlags.RENDER_AREAS
    kwargs = {}
    if args.areas:
        with open(args.areas) as f:
            for line in f:
                if line.startswith("#"):
                    continue
                if '=' not in line:
                    continue
                outfile, area = line.split('=')
                args.area = area.strip().split(',')
                args.outfile = outfile.strip()
                renderMap(args)
    else:
        renderMap(args)
