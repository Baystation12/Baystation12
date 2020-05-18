/turf
	var/dynamic_lighting = TRUE    // Does the turf use dynamic lighting?
	luminosity           = 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/list/datum/light_source/affecting_lights       // List of light sources affecting this turf.
	var/tmp/atom/movable/lighting_overlay/lighting_overlay // Our lighting overlay.
	var/tmp/list/datum/lighting_corner/corners
	var/opaque_counter

/turf/set_opacity()
	. = ..()
	handle_opacity_change(src)

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	for(var/datum/light_source/L in affecting_lights)
		L.vis_update()

/turf/proc/lighting_clear_overlay()
	if(lighting_overlay)
		qdel(lighting_overlay)

	for(var/datum/lighting_corner/C in corners)
		C.update_active()

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if(lighting_overlay)
		return

	var/area/A = loc
	if(A.dynamic_lighting && dynamic_lighting)
		if(!lighting_corners_initialised)
			generate_missing_corners()

		new /atom/movable/lighting_overlay(src)

		for(var/datum/lighting_corner/C in corners)
			if(!C.active) // We would activate the corner, calculate the lighting for it.
				for(var/L in C.affecting)
					var/datum/light_source/S = L
					S.recalc_corner(C)

				C.active = TRUE

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(var/minlum = 0, var/maxlum = 1)
	if(!lighting_overlay)
		var/area/A = loc
		if(A.dynamic_lighting && dynamic_lighting)
			var/atom/movable/lighting_overlay/O = new /atom/movable/lighting_overlay(src)
			lighting_overlay = O

	var/totallums = 0
	for(var/datum/lighting_corner/L in corners)
		totallums += max(L.lum_r, L.lum_g, L.lum_b)

	totallums /= 4 // 4 corners, max channel selected, return the average

	totallums =(totallums - minlum) /(maxlum - minlum)

	return CLAMP01(totallums)

// If an opaque movable atom moves around we need to potentially update visibility.
/turf/Entered(var/atom/movable/Obj, var/atom/OldLoc)
	. = ..()
	if(Obj && Obj.opacity)
		if(!opaque_counter++)
			reconsider_lights()

/turf/Exited(var/atom/movable/Obj, var/atom/newloc)
	. = ..()
	if(Obj && Obj.opacity)
		if(!(--opaque_counter))
			reconsider_lights()

/turf/proc/get_corners()
	if(opaque_counter)
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return corners

/turf/proc/generate_missing_corners()
	lighting_corners_initialised = TRUE
	if(!corners)
		corners = list(null, null, null, null)

	for(var/i = 1 to 4)
		if(corners[i]) // Already have a corner on this direction.
			continue

		corners[i] = new /datum/lighting_corner(src, LIGHTING_CORNER_DIAGONAL[i])

/turf/proc/handle_opacity_change(var/atom/opacity_changer)
	if(opacity_changer)
		if(opacity_changer.opacity)
			if(!opaque_counter)
				reconsider_lights()
			opaque_counter++
		else
			var/old_counter = opaque_counter
			opaque_counter--
			if(old_counter && !opaque_counter)
				reconsider_lights()
