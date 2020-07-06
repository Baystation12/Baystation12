
/atom/movable/proc/check_elevation_impact(var/mob/living/to_impact)
	return 0

/obj/effect/explosion_crater
	name = "crater"
	desc = "A crater caused by an explosion. Provides cover when stood in."
	icon = 'code/modules/halo/misc/explosion_craters.dmi'
	icon_state = "medium"
	var/elevation_impact = -1 //The base elevation of the turf is impacted in this way
	var/apply_prone_only = 0

/obj/effect/explosion_crater/New(var/turf/spawnloc)
	. = ..()
	var/turf/impacting = loc
	if(istype(impacting))
		impacting.elevation_impacters += src

/obj/effect/explosion_crater/Destroy()
	var/turf/impacting = loc
	if(istype(impacting))
		impacting.elevation_impacters -= src
	. = ..()

/obj/effect/explosion_crater/check_elevation_impact(var/mob/living/to_impact)
	if(to_impact.elevation != BASE_ELEVATION)
		return 0
	if(apply_prone_only)
		if(to_impact.lying)
			to_chat(to_impact,"<span class = 'notice'>You lie down inside \the [src].</span>")
			return elevation_impact
		return 0
	else
		to_chat(to_impact,"<span class = 'notice'>You step into \the [src].</span>")
		return elevation_impact

/obj/effect/explosion_crater/light
	name = "shallow crater"
	desc = "A crater in the ground, caused by an explosion. This one is shallow, so lie down to benefit from the cover it provides."
	icon_state = "light"
	apply_prone_only = 1