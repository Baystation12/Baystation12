/// Does the turf use dynamic lighting?
/turf/var/dynamic_lighting = TRUE
/turf/luminosity           = 1

/turf/var/tmp/lighting_corners_initialised = FALSE

/// List of light sources affecting this turf.
/turf/var/tmp/list/datum/light_source/affecting_lights
/// Our lighting overlay.
/turf/var/tmp/atom/movable/lighting_overlay/lighting_overlay
/turf/var/tmp/list/datum/lighting_corner/corners
/turf/var/opaque_counter

/turf/set_opacity(new_opacity)
	. = ..()
	if(opacity == new_opacity)
		return FALSE

	opacity = new_opacity
	return RecalculateOpacity()

/turf/proc/RecalculateOpacity()
	var/old_opaque_counter = opaque_counter

	opaque_counter = opacity
	for(var/a in src)
		var/atom/A = a
		opaque_counter += A.opacity

	// If the counter changed and was or became 0 then lift event/reconsider lights
	if(opaque_counter != old_opaque_counter && (!opaque_counter || !old_opaque_counter))
		GLOB.opacity_set_event.raise_event(src, !opaque_counter, !!opaque_counter)
		reconsider_lights()
		return TRUE
	return FALSE

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
/turf/Entered(var/atom/movable/AM, var/atom/OldLoc)
	. = ..()
	if(AM?.opacity)
		RecalculateOpacity()

/turf/Exited(var/atom/movable/AM, var/atom/newloc)
	. = ..()
	if(AM?.opacity)
		RecalculateOpacity()

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
