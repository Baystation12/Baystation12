/*

Overview:
	Perhaps the most cryptic datum in the lighting engine, there are four of these at the corners of every turf.
	Any two turfs that share a corner will also have the same lightpoint. Because of the nature of the icons used,
	light is shown at the corner of the turf rather than in the middle, necessitating some way to keep track of what
	icon state to use.

Class Vars:
	x, y, z - The position of the lightpoint. x and y will usually be expressed in terms of 0.5 due to its location on the corner.

	NE, NW, SE, SW - The turfs that are in these directions relative to the lightpoint.

	cached_value - A cached value of max_value().

Class Procs:
	max_value()
		The maximum of the light amounts on the four turfs of this light point.

*/

lightpoint
	var/x
	var/y
	var/z

	var/turf/NE
	var/turf/NW
	var/turf/SW
	var/turf/SE

	var/cached_value = -1

	New(x,y,z)
		var/turf/T = locate(x+0.5,y+0.5,z)
		if(T)
			NE = T
			T.lightSW = src
		T = locate(x-0.5,y+0.5,z)
		if(T)
			NW = T
			T.lightSE = src
		T = locate(x-0.5,y-0.5,z)
		if(T)
			SW = T
			T.lightNE = src
		T = locate(x+0.5,y-0.5,z)
		if(T)
			SE = T
			T.lightNW = src

	proc/max_value()
		var
			valueA = VALUE_OF(NW)
			valueB = VALUE_OF(NE)
			valueC = VALUE_OF(SW)
			valueD = VALUE_OF(SE)
		cached_value = max(valueA,valueB,valueC,valueD)
		return cached_value