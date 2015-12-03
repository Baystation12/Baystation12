/datum/turf_effect/space
	var/travel_direction
	var/list/entered_mobs
	var/list/origin_turfs
	var/list/turf_to_mobs

/datum/turf_effect/space/New()
	entered_mobs = list()
	origin_turfs = list()
	turf_to_mobs = list()
	..()

/datum/turf_effect/space/Destroy()
	entered_mobs.Cut()
	origin_turfs.Cut()
	turf_to_mobs.Cut()
	..()

/datum/turf_effect/space/proc/add_origin(var/turf/source)

/datum/turf_effect/space/entered(var/turf/source, var/atom/A)
	return

/datum/turf_effect/space/exited(var/turf/source, var/atom/A)
	return

/datum/turf_effect/space/process()
	return PROCESS_KILL
