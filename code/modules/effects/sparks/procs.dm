// -- Spark Procs --
/proc/spark(var/atom/movable/loc, var/amount = 1, var/spread_dirs = cardinal)
	new /datum/effect_system/sparks(get_turf(loc), TRUE, amount, spread_dirs)

/proc/bind_spark(var/atom/movable/loc, var/amount = 1, var/spread_dirs = cardinal)
	var/datum/effect_system/sparks/S = new(loc, FALSE, amount, spread_dirs)
	S.bind(loc)
	return S

/proc/single_spark(var/turf/loc)
	spark(loc, spread_dirs = list())
