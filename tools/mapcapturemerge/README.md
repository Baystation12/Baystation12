Map capture merge tool manual
======

1. Capture desired Z levels using in game verb `Capture-map`
2. Before closing game window, go to cache folder usually located under Documents/BYOND and copy all map capture files named like `map_capture_x1_y33_z1_r32.png` to folder under this tool called `captures`.
3. Install *Python* and *Pillow* library (If you don't have them already).
4. Run `python merge.py` and wait for captures to be merged.
5. After execution you will find all z-level merged maps in the mapcapturemerge tool folder.

Notes:
 * This tool been tested with Python 2.7.6 under Windows 10 Bash.