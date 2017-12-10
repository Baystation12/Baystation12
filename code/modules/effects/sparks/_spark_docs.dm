/*

/proc/spark(var/atom/movable/loc, var/amount = 1, var/spread_dirs = cardinal)
Creates a spark system that is destroyed once the animation completes.
	loc:	The location this effect should be created at. Does not need to be a turf.
	amount:	How many spark-tiles should be created.
	spread_dirs:	The directions the sparks should spread in. 'cardinal' if not specified.

/proc/bind_spark(var/atom/movable/loc, var/amount = 1, var/spread_dirs = cardinal)
Creates a spark system that can be stored in a variable and reused multiple times with queue().
	loc:	The atom to bind this effect to.
	amount:	How many spark-tiles should be created.
	spread_dirs:	The directions the sparks should spread in. 'cardinal' if not specified.

/proc/single_spark(var/turf/loc)
Creates a single tile of sparks.
	loc:	The location the spark should be created at.

*/
