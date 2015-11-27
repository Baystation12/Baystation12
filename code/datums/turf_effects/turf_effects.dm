/datum/turf_effect/New()
	processing_turf_effects += src
	..()

/datum/turf_effect/Destroy()
	processing_turf_effects -= src
	return ..()

/datum/turf_effect/proc/entered(var/turf/source, var/atom/A)
	return

/datum/turf_effect/proc/exited(var/turf/source, var/atom/A)
	return

/datum/turf_effect/proc/update_icon(var/turf/source)
	return

/datum/turf_effect/proc/turf_destroyed(var/turf/source)
	return

/datum/turf_effect/proc/process()
	return PROCESS_KILL

/*****************
* Turf Additions *
*****************/
/turf
	var/list/datum/turf_effect/turf_effects

/turf/New()
	turf_effects = list()
	..()

/turf/Destroy()
	turf_effects.Cut()
	return ..()

/turf/Entered(atom/movable/obj)
	. = ..()
	for(var/datum/turf_effect/TE in turf_effects)
		TE.entered(src, obj)

/turf/Exited(atom/movable/obj)
	. = ..()
	for(var/datum/turf_effect/TE in turf_effects)
		TE.exited(src, obj)

/turf/update/update_icon()
	..()
	for(var/datum/turf_effect/TE in turf_effects)
		TE.update_icon(src)

/turf/proc/add_effect(var/datum/turf_effect/TE)
	turf_effects += TE
	update_icon()

/turf/proc/remove_effect(var/datum/turf_effect/TE)
	turf_effects -= TE
	update_icon()
