var/global/total_lighting_sources = 0
// This is where the fun begins.
// These are the main datums that emit light.

/datum/light_source
	var/atom/top_atom        // The atom we're emitting light from(for example a mob if we're from a flashlight that's being held).
	var/atom/source_atom     // The atom that we belong to.

	var/turf/source_turf     // The turf under the above.
	var/light_max_bright = 1  // intensity of the light within the full brightness range. Value between 0 and 1
	var/light_inner_range = 0 // range, in tiles, the light is at full brightness
	var/light_outer_range = 0 // range, in tiles, where the light becomes darkness
	var/light_falloff_curve   // adjusts curve for falloff gradient
	var/light_color    // The colour of the light, string, decomposed by parse_light_color()

	// Variables for keeping track of the colour.
	var/lum_r
	var/lum_g
	var/lum_b

	// The lumcount values used to apply the light.
	var/tmp/applied_lum_r
	var/tmp/applied_lum_g
	var/tmp/applied_lum_b

	var/list/datum/lighting_corner/effect_str     // List used to store how much we're affecting corners.
	var/list/turf/affecting_turfs

	var/applied = FALSE // Whether we have applied our light yet or not.

	var/vis_update      // Whether we should smartly recalculate visibility. and then only update tiles that became(in)visible to us.
	var/needs_update    // Whether we are queued for an update.
	var/destroyed       // Whether we are destroyed and need to stop emitting light.
	var/force_update

/datum/light_source/New(var/atom/owner, var/atom/top)
	total_lighting_sources++
	source_atom = owner // Set our new owner.
	if(!source_atom.light_sources)
		source_atom.light_sources = list()

	source_atom.light_sources += src // Add us to the lights of our owner.
	top_atom = top
	if(top_atom != source_atom)
		if(!top.light_sources)
			top.light_sources     = list()

		top_atom.light_sources += src

	source_turf = top_atom
	light_max_bright = source_atom.light_max_bright
	light_inner_range = source_atom.light_inner_range
	light_outer_range = source_atom.light_outer_range
	light_falloff_curve = source_atom.light_falloff_curve
	light_color = source_atom.light_color

	parse_light_color()

	effect_str      = list()
	affecting_turfs = list()

	update()


	return ..()

/* lighting debugging verb
/mob/verb/self_light()
	set name = "set self light"
	set category = "Light"
	var/v1 = input(usr, "Enter max bright", "max bright", 1) as num|null
	var/v2 = input(usr, "Enter inner range", "inner range", 0.1) as num|null
	var/v3 = input(usr, "Enter outer range", "outer range", 4) as num|null
	var/v4 = input(usr, "Enter curve", "curve", 2) as num|null
	set_light(v1, v2, v3, v4, "#0066ff")
*/

// Kill ourselves.
/datum/light_source/proc/destroy()
	total_lighting_sources--
	destroyed = TRUE
	force_update()
	if(source_atom && source_atom.light_sources)
		source_atom.light_sources -= src

	if(top_atom && top_atom.light_sources)
		top_atom.light_sources    -= src

// Call it dirty, I don't care.
// This is here so there's no performance loss on non-instant updates from the fact that the engine can also do instant updates.
// If you're wondering what's with the "BYOND" argument: BYOND won't let me have a() macro that has no arguments :|.
#define effect_update(BYOND)            \
	if(!needs_update)                  \
	{                                   \
		SSlighting.light_queue += src;  \
		needs_update            = TRUE; \
	}

// This proc will cause the light source to update the top atom, and add itself to the update queue.
/datum/light_source/proc/update(var/atom/new_top_atom)
	// This top atom is different.
	if(new_top_atom && new_top_atom != top_atom)
		if(top_atom != source_atom) // Remove ourselves from the light sources of that top atom.
			top_atom.light_sources -= src

		top_atom = new_top_atom

		if(top_atom != source_atom)
			if(!top_atom.light_sources)
				top_atom.light_sources = list()

			top_atom.light_sources += src // Add ourselves to the light sources of our new top atom.

	effect_update(null)

// Will force an update without checking if it's actually needed.
/datum/light_source/proc/force_update()
	force_update = 1

	effect_update(null)

// Will cause the light source to recalculate turfs that were removed or added to visibility only.
/datum/light_source/proc/vis_update()
	vis_update = 1

	effect_update(null)

// Will check if we actually need to update, and update any variables that may need to be updated.
/datum/light_source/proc/check()
	if(!source_atom || !light_outer_range || !light_max_bright)
		destroy()
		return 1

	if(!top_atom)
		top_atom = source_atom
		. = 1

	if(isturf(top_atom))
		if(source_turf != top_atom)
			source_turf = top_atom
			. = 1
	else if(top_atom.loc != source_turf)
		source_turf = top_atom.loc
		. = 1

	if(source_atom.light_max_bright != light_max_bright)
		light_max_bright = source_atom.light_max_bright
		. = 1

	if(source_atom.light_inner_range != light_inner_range)
		light_inner_range = source_atom.light_inner_range
		. = 1

	if(source_atom.light_outer_range != light_outer_range)
		light_outer_range = source_atom.light_outer_range
		. = 1

	if(source_atom.light_falloff_curve != light_falloff_curve)
		light_falloff_curve = source_atom.light_falloff_curve
		. = 1

	if(light_max_bright && light_outer_range && !applied)
		. = 1

	if(source_atom.light_color != light_color)
		light_color = source_atom.light_color
		parse_light_color()
		. = 1

// Decompile the hexadecimal colour into lumcounts of each perspective.
/datum/light_source/proc/parse_light_color()
	if(light_color)
		lum_r = GetRedPart  (light_color) / 255
		lum_g = GetGreenPart(light_color) / 255
		lum_b = GetBluePart (light_color) / 255
	else
		lum_r = 1
		lum_g = 1
		lum_b = 1

// Macro that applies light to a new corner.
// It is a macro in the interest of speed, yet not having to copy paste it.
// If you're wondering what's with the backslashes, the backslashes cause BYOND to not automatically end the line.
// As such this all gets counted as a single line.
// The braces and semicolons are there to be able to do this on a single line.

#define APPLY_CORNER(C)              \
	. = LUM_FALLOFF(C, source_turf); \
	. *= (light_max_bright ** 2);    \
	. *= light_max_bright < 0 ? -1:1;\
	effect_str[C] = .;               \
	C.update_lumcount                \
	(                                \
		. * applied_lum_r,           \
		. * applied_lum_g,           \
		. * applied_lum_b            \
	);

// I don't need to explain what this does, do I?
#define REMOVE_CORNER(C)             \
	. = -effect_str[C];              \
	C.update_lumcount                \
	(                                \
		. * applied_lum_r,           \
		. * applied_lum_g,           \
		. * applied_lum_b            \
	);

// This is the define used to calculate falloff.
// Assuming a brightness of 1 at range 1, formula should be (brightness = 1 / distance^2)
// However, due to the weird range factor, brightness = (-(distance - full_dark_start) / (full_dark_start - full_light_end)) ^ light_max_bright

#define LUM_FALLOFF(C, T)(CLAMP01(-((((C.x - T.x) ** 2 +(C.y - T.y) ** 2) ** 0.5 - light_outer_range) / max(light_outer_range - light_inner_range, 1))) ** light_falloff_curve)


/datum/light_source/proc/apply_lum()
	var/static/update_gen = 1
	applied = 1

	// Keep track of the last applied lum values so that the lighting can be reversed
	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

	FOR_DVIEW(var/turf/T, light_outer_range, source_turf, INVISIBILITY_LIGHTING)
		check_t:
		if (!T)
			continue
		if(!T.lighting_corners_initialised)
			T.generate_missing_corners()

		for(var/datum/lighting_corner/C in T.get_corners())
			if(C.update_gen == update_gen)
				continue

			C.update_gen = update_gen
			C.affecting += src

			if(!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER(C)

		LAZYADD(T.affecting_lights, src)
		affecting_turfs += T

		if (T.z_flags & ZM_ALLOW_LIGHTING)
			T = T.below
			goto check_t

	END_FOR_DVIEW

	update_gen++

/datum/light_source/proc/remove_lum()
	applied = FALSE

	for(var/turf/T in affecting_turfs)
		LAZYREMOVE(T.affecting_lights, src)

	affecting_turfs.Cut()

	for(var/datum/lighting_corner/C in effect_str)
		REMOVE_CORNER(C)

		C.affecting -= src

	effect_str.Cut()

/datum/light_source/proc/recalc_corner(var/datum/lighting_corner/C)
	if(list_find(effect_str, C)) // Already have one.
		REMOVE_CORNER(C)

	APPLY_CORNER(C)

/datum/light_source/proc/smart_vis_update()
	var/list/datum/lighting_corner/corners = list()
	var/list/turf/turfs                    = list()
	FOR_DVIEW(var/turf/T, light_outer_range, source_turf, 0)
		if (!T)
			continue
		if(!T.lighting_corners_initialised)
			T.generate_missing_corners()
		corners |= T.get_corners()
		turfs   += T

		var/turf/simulated/open/O = T
		if(istype(O) && O.below)
			// Consider the turf below us as well. (Z-lights)
			for(T = O.below; !isnull(T); T = update_the_turf(T,corners, turfs));
	END_FOR_DVIEW

	var/list/L = turfs - affecting_turfs // New turfs, add us to the affecting lights of them.
	affecting_turfs += L
	for(var/turf/T in L)
		LAZYADD(T.affecting_lights, src)

	L = affecting_turfs - turfs // Now-gone turfs, remove us from the affecting lights.
	affecting_turfs -= L
	for(var/turf/T in L)
		LAZYREMOVE(T.affecting_lights, src)

	for(var/datum/lighting_corner/C in corners - effect_str) // New corners
		C.affecting += src
		if(!C.active)
			effect_str[C] = 0
			continue

		APPLY_CORNER(C)

	for(var/datum/lighting_corner/C in effect_str - corners) // Old, now gone, corners.
		REMOVE_CORNER(C)
		C.affecting -= src
		effect_str -= C


/datum/light_source/proc/update_the_turf(var/turf/T, var/list/datum/lighting_corner/corners, var/list/turf/turfs)
	if(!T.lighting_corners_initialised)
		T.generate_missing_corners()
	corners |= T.get_corners()
	turfs   += T

	var/turf/simulated/open/O = T
	if(istype(O) && O.below)
		return O.below
	return null

#undef effect_update
#undef LUM_FALLOFF
#undef REMOVE_CORNER
#undef APPLY_CORNER
