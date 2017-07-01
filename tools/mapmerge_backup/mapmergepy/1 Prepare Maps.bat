@echo off
cd ../../../maps/

for /R %%f in (*.dmm) do copy "%%f" "%%f.backup"

cls
echo All dmm files in maps directories have been backed up
echo Now you can make your changes...
echo ---
echo Remember to run Run_Map_Merge.bat just before you commit your changes!
echo ---
pause
