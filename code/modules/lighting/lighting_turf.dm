/turf
	var/dynamic_lighting = TRUE
	var/ambient_light	// If non-null, a hex RGB light color that should be applied to this turf.
	var/ambient_light_multiplier = 0.3	// The power of the above is multiplied by this. Setting too high may drown out normal lights on the same turf.
	luminosity           = 1

	var/lighting_corners_initialised = FALSE

	var/list/datum/light_source/affecting_lights       // List of light sources affecting this turf.
	var/atom/movable/lighting_overlay/lighting_overlay // Our lighting overlay.
	var/list/datum/lighting_corner/corners

	var/ambient_has_indirect = FALSE // If this is TRUE, an above turf's ambient light is affecting this turf.

	// Record-keeping, do not touch -- that means you, admins.
	var/ambient_active = FALSE	//! Do we have non-zero ambient light? Use [TURF_IS_AMBIENT_LIT] instead of reading this directly.
	var/ambient_light_old_r = 0
	var/ambient_light_old_g = 0
	var/ambient_light_old_b = 0

	var/ambient_bitflag = 0

//Done on init if mapload, done post copying corners if changeturf
/turf/proc/setup_local_ambient()
	return

/turf/Initialize(mapload, ...)
	. = ..()
	if(mapload)
		setup_local_ambient()

/turf/proc/set_ambient_light(color, multiplier)
	if (color == ambient_light && multiplier == ambient_light_multiplier)
		return

	ambient_light = color || ambient_light
	ambient_light_multiplier = multiplier || ambient_light_multiplier
	if (!ambient_light_multiplier)
		ambient_light_multiplier = initial(ambient_light_multiplier)

	update_ambient_light()

/turf/proc/replace_ambient_light(old_color, new_color, old_multiplier, new_multiplier = 0)
	if (!TURF_IS_AMBIENT_LIT_UNSAFE(src))
		add_ambient_light(new_color, new_multiplier)
		return

	ASSERT(old_multiplier)	// omitting new_multiplier is allowed for removing light nondestructively

	old_color ||= COLOR_WHITE
	new_color ||= COLOR_WHITE

	var/list/old_parts = rgb2num(old_color)
	var/list/new_parts = rgb2num(new_color)

	var/dr = (new_parts[1] / 255) * new_multiplier - (old_parts[1] / 255) * old_multiplier
	var/dg = (new_parts[2] / 255) * new_multiplier - (old_parts[2] / 255) * old_multiplier
	var/db = (new_parts[3] / 255) * new_multiplier - (old_parts[3] / 255) * old_multiplier

	if (!dr && !dg && !db)
		return

	add_ambient_light_raw(dr, dg, db)

/turf/proc/add_ambient_light(color, multiplier, update = TRUE)
	if (!color)
		return

	multiplier ||= ambient_light_multiplier

	var/list/ambient_parts = rgb2num(color)

	var/ambient_r = (ambient_parts[1] / 255) * multiplier
	var/ambient_g = (ambient_parts[2] / 255) * multiplier
	var/ambient_b = (ambient_parts[3] / 255) * multiplier

	add_ambient_light_raw(ambient_r, ambient_g, ambient_b, update)

/turf/proc/add_ambient_light_raw(lr, lg, lb, update = TRUE)
	if (!lr && !lg && !lb)
		if (!ambient_light_old_r || !ambient_light_old_g || !ambient_light_old_b)
			ambient_active = FALSE
			SSlighting.total_ambient_turfs -= 1
		return

	if (!ambient_active)
		SSlighting.total_ambient_turfs += 1
		ambient_active = TRUE

	// There are four corners per (lit) turf, we don't want to apply our light 4 times -- compensate by dividing by 4.
	lr /= 4
	lg /= 4
	lb /= 4

	lr = round(lr, LIGHTING_ROUND_VALUE)
	lg = round(lg, LIGHTING_ROUND_VALUE)
	lb = round(lb, LIGHTING_ROUND_VALUE)

	ambient_light_old_r += lr
	ambient_light_old_g += lg
	ambient_light_old_b += lb

	if (!corners || !lighting_corners_initialised)
		generate_missing_corners()

	// This list can contain nulls on things like space turfs -- they only have their neighbors' corners.
	for (var/datum/lighting_corner/C in corners)
		C.update_ambient_lumcount(lr, lg, lb, !update)

/turf/proc/clear_ambient_light()
	if (isnull(ambient_light))
		return

	ambient_light = null
	update_ambient_light()

/turf/proc/update_ambient_light(no_corner_update = FALSE)
	// These are deltas.
	var/ambient_r = 0
	var/ambient_g = 0
	var/ambient_b = 0

	if (ambient_light)
		var/list/parts = rgb2num(ambient_light)
		ambient_r = ((parts[1] / 255) * ambient_light_multiplier) - ambient_light_old_r
		ambient_g = ((parts[2] / 255) * ambient_light_multiplier) - ambient_light_old_g
		ambient_b = ((parts[3] / 255) * ambient_light_multiplier) - ambient_light_old_b
	else
		ambient_r = -ambient_light_old_r
		ambient_g = -ambient_light_old_g
		ambient_b = -ambient_light_old_b

	add_ambient_light_raw(ambient_r, ambient_g, ambient_b, !no_corner_update)

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.vis_update()

// Forces a lighting update. Reconsider lights is preferred when possible.
/turf/proc/force_update_lights()
	var/datum/light_source/L
	for (var/thing in affecting_lights)
		L = thing
		L.force_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_overlay)
		if (lighting_overlay.loc != src)
			stack_trace("Lighting overlay variable on turf [log_info_line(src)] is insane, lighting overlay actually located on [log_info_line(lighting_overlay.loc)]!")

		qdel(lighting_overlay, TRUE)
		lighting_overlay = null

	for (var/datum/lighting_corner/C in corners)
		C.update_active()

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay(now = FALSE)
	if (lighting_overlay)
		return //In Cit this wont happen, bay has a slightly different init so just returning is fine
		//CRASH("Attempted to create lighting_overlay on tile that already had one.")

	if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
		if (!lighting_corners_initialised || !corners)
			generate_missing_corners()

		new /atom/movable/lighting_overlay(src, now)

		for (var/datum/lighting_corner/C in corners)
			if (!C.active) // We would activate the corner, calculate the lighting for it.
				for (var/L in C.affecting)
					var/datum/light_source/S = L
					S.recalc_corner(C, TRUE)

				C.active = TRUE

// Returns the average color of this tile. Roughly corresponds to the color of a single old-style lighting overlay.
/turf/proc/get_avg_color()
	if (!lighting_overlay)
		return null

	var/lum_r
	var/lum_g
	var/lum_b

	for (var/datum/lighting_corner/L in corners)
		lum_r += L.apparent_r
		lum_g += L.apparent_g
		lum_b += L.apparent_b

	lum_r = CLAMP01(lum_r / 4) * 255
	lum_g = CLAMP01(lum_g / 4) * 255
	lum_b = CLAMP01(lum_b / 4) * 255

	return "#[num2hex(lum_r)][num2hex(lum_g)][num2hex(lum_b)]"

#define SCALE(targ,min,max) (targ - min) / (max - min)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_overlay)
		return 0.5

	var/totallums = 0
	for (var/datum/lighting_corner/L in corners)
		totallums += L.apparent_r + L.apparent_b + L.apparent_g

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = SCALE(totallums, minlum, maxlum)

	return CLAMP01(totallums)

#undef SCALE

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
#ifdef AO_USE_LIGHTING_OPACITY
	var/old = has_opaque_atom
#endif

	has_opaque_atom = FALSE
	if (opacity)
		has_opaque_atom = TRUE
	else
		for (var/thing in src) // Loop through every movable atom on our tile
			var/atom/movable/A = thing
			if (A.opacity)
				has_opaque_atom = TRUE
				break 	// No need to continue if we find something opaque.

#ifdef AO_USE_LIGHTING_OPACITY
	if (old != has_opaque_atom)
		regenerate_ao()
#endif

/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (!Obj)
		return

	if (Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

// This block isn't needed now, but it's here if supporting area dyn lighting changes is needed later.

// /turf/change_area(area/old_area, area/new_area)
// 	if (new_area.dynamic_lighting != old_area.dynamic_lighting)
// 		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
// 			lighting_build_overlay()
// 		else
// 			lighting_clear_overlay()

// This is inlined in lighting_source.dm.
// Update it too if you change this.
/turf/proc/generate_missing_corners()
	if (!TURF_IS_DYNAMICALLY_LIT_UNSAFE(src) && !light_source_solo && !light_source_multi && !(z_flags & ZM_ALLOW_LIGHTING) && !ambient_light && !ambient_has_indirect)
		return

	lighting_corners_initialised = TRUE
	if (!corners)
		corners = new(4)

	for (var/i = 1 to 4)
		if (corners[i]) // Already have a corner on this direction.
			continue

		corners[i] = new/datum/lighting_corner(src, LIGHTING_CORNER_DIAGONAL[i], i)
