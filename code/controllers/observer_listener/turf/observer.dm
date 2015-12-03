#define OBSERVER_ON_TURF_CHANGED "OnTurfChanged"

/turf/ChangeTurf()
	var/turf/new_turf = ..()
	if(istype(new_turf))
		raise_event(OBSERVER_ON_TURF_CHANGED, list(src, new_turf))
