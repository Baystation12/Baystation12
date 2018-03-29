# Map Merge 2

**Map Merge 2** is an improvement over previous map merging scripts, with
better merge-conflict prevention, multi-Z support, and automatic handling of
key overflow.

## What Map Merging Is

The "map merge" operation describes the process of rewriting a map file written
by the DreamMaker map editor to A) use a format more amenable to Git's conflict
resolution and B) differ in the least amount textually from the previous
version of the map while maintaining all the actual changes. It requires an old
version of the map to use as a reference and a new version of the map which
contains the desired changes.

## Installation

To install Python dependencies, run `requirements-install.bat`, or run
`python -m pip install -r requirements.txt` directly. Make sure you have Python 3.5 or higher before doing so. See the [Git hooks]
documentation to install the Git pre-commit hook which runs the map merger
automatically, or use `tools/mapmerge/Prepare Maps.bat` to save backups before
running `mapmerge.bat`.

For up-to-date installation and detailed troubleshooting instructions, visit
the [Map Merger] wiki article.

## Usage

Assuming you've already installed the Python dependencies. Follow the steps below,

1. Run Prepare Maps.bat as this provides backups before making changes to a map. It also makes the mapmerger actually work.

2. Edit your map.

3. Run mapmerge.bat (unless you've setup the mapmerger2 hooks)

4. Commit your changes and you're done!

Note: Do not open the map in dreammaker before committing the results of mapmerger - this can cause dreammaker to save back into the default dmm format. If you're having issues with your map getting stuck in dmm mode, try committing and pushing the mapmerger changes before reopening in dreammaker.

## Code Structure

Frontend scripts are meant to be run directly. They obey the environment
variables `TGM` to set whether files are saved in TGM (1) or DMM (0) format,
and `MAPROOT` to determine where maps are kept. By default, TGM is used and
the map root is autodetected. Each script may either prompt for the desired map
or be run with command-line parameters indicating which maps to act on. The
scripts include:

* `convert.py` for converting maps to and from the TGM format. Used by
  `tgm2dmm.bat` and `dmm2tgm.bat`.
* `mapmerge.py` for running the map merge on map backups saved by
  `Prepare Maps.bat`. Used by `mapmerge.bat`

Implementation modules:

* `dmm.py` includes the map reader and writer.
* `mapmerge.py` includes the implementation of the map merge operation.
* `frontend.py` includes the common code for the frontend scripts.

`precommit.py` is run by the [Git hooks] if installed, and merges the new
version of any map saved in the index (`git add`ed) with the old version stored
in Git when run.

[Map Merger]: https://tgstation13.org/wiki/Map_Merger
[Git hooks]: ../hooks/README.md
