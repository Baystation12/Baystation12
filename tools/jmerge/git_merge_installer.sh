F="../../.git/config"

echo '' >> $F
echo '[merge "merge-dmm"]' >> $F
echo '	name = mapmerge driver' >> $F
echo '	driver = ./tools/jmerge/mapmerge.sh %O %A %B' >> $F
