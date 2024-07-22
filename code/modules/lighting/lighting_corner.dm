var/global/datum/lighting_corner/dummy/dummy_lighting_corner = new
// Because we can control each corner of every lighting overlay.
// And corners get shared between multiple turfs (unless you're on the corners of the map, then 1 corner doesn't).
// For the record: these should never ever ever be deleted, even if the turf doesn't have dynamic lighting.

// This list is what the code that assigns corners listens to, the order in this list is the order in which corners are added to the /turf/corners list.
var/global/list/LIGHTING_CORNER_DIAGONAL = list(NORTHEAST, SOUTHEAST, SOUTHWEST, NORTHWEST)

// This is the reverse of the above - the position in the array is a dir. Update this if the above changes.
var/global/list/REVERSE_LIGHTING_CORNER_DIAGONAL = list(0, 0, 0, 0, 3, 4, 0, 0, 2, 1)

/datum/lighting_corner
	// t1 through t4 are our masters, in no particular order.
	// They are split into vars like this in the interest of reducing memory usage.
	// tX is the turf itself, tXi is the index of this corner in that turf's corners list.
	var/turf/t1
	var/t1i
	var/turf/t2
	var/t2i
	var/turf/t3
	var/t3i
	var/turf/t4
	var/t4i

	var/list/datum/light_source/affecting // Light sources affecting us.
	var/active                            = FALSE  // TRUE if one of our masters has dynamic lighting.

	var/x = 0
	var/y = 0
	var/z = 0

	// Our own intensity, from lights directly shining on us.
	var/self_r = 0
	var/self_g = 0
	var/self_b = 0

	// The intensity we're inheriting from the turf below us, if we're a Z-turf.
	var/below_r = 0
	var/below_g = 0
	var/below_b = 0

	// Ambient turf lighting that's not inherited from a light source. These are updated as absolute values.
	var/ambient_r = 0
	var/ambient_g = 0
	var/ambient_b = 0

	// The turf above us' ambient
	var/above_ambient_r = 0
	var/above_ambient_g = 0
	var/above_ambient_b = 0

	// The final intensity, all things considered.
	var/apparent_r = 0
	var/apparent_g = 0
	var/apparent_b = 0

	var/needs_update = FALSE

	var/cache_r  = 0
	var/cache_g  = 0
	var/cache_b  = 0
	var/cache_mx = 0

	/// Used for planet lighting. Probably needs a better system to prevent over-updating when not needed at some point.
	var/update_gen = 0

/datum/lighting_corner/New(turf/new_turf, diagonal, oi)
	SSlighting.total_lighting_corners += 1

	var/has_ambience = FALSE

	t1 = new_turf
	z = new_turf.z
	t1i = oi

	if (TURF_IS_AMBIENT_LIT_UNSAFE(new_turf))
		has_ambience = TRUE

	var/vertical   = diagonal & ~(diagonal - 1) // The horizontal directions (4 and 8) are bigger than the vertical ones (1 and 2), so we can reliably say the lsb is the horizontal direction.
	var/horizontal = diagonal & ~vertical       // Now that we know the horizontal one we can get the vertical one.

	x = new_turf.x + (horizontal == EAST  ? 0.5 : -0.5)
	y = new_turf.y + (vertical   == NORTH ? 0.5 : -0.5)

	// My initial plan was to make this loop through a list of all the dirs (horizontal, vertical, diagonal).
	// Issue being that the only way I could think of doing it was very messy, slow and honestly overengineered.
	// So we'll have this hardcode instead.
	var/turf/T


	// Diagonal one is easy.
	T = get_step(new_turf, diagonal)
	if (T) // In case we're on the map's border.
		if (!T.corners)
			T.corners = new(4)

		t2 = T
		t2i = REVERSE_LIGHTING_CORNER_DIAGONAL[diagonal]
		T.corners[t2i] = src
		if (TURF_IS_AMBIENT_LIT_UNSAFE(T))
			has_ambience = TRUE

	// Now the horizontal one.
	T = get_step(new_turf, horizontal)
	if (T) // Ditto.
		if (!T.corners)
			T.corners = new(4)

		t3 = T
		t3i = REVERSE_LIGHTING_CORNER_DIAGONAL[((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		T.corners[t3i] = src
		if (TURF_IS_AMBIENT_LIT_UNSAFE(T))
			has_ambience = TRUE

	// And finally the vertical one.
	T = get_step(new_turf, vertical)
	if (T)
		if (!T.corners)
			T.corners = new(4)

		t4 = T
		t4i = REVERSE_LIGHTING_CORNER_DIAGONAL[((T.x > x) ? EAST : WEST) | ((T.y > y) ? NORTH : SOUTH)] // Get the dir based on coordinates.
		T.corners[t4i] = src
		if (TURF_IS_AMBIENT_LIT_UNSAFE(T))
			has_ambience = TRUE

	update_active()
	if (has_ambience)
		init_ambient()

#define OVERLAY_PRESENT(T) (T && T.lighting_overlay)

/datum/lighting_corner/proc/update_active()
	active = FALSE

	if (OVERLAY_PRESENT(t1) || OVERLAY_PRESENT(t2) || OVERLAY_PRESENT(t3) || OVERLAY_PRESENT(t4))
		active = TRUE

#undef OVERLAY_PRESENT

#define GET_ABOVE(T) (HasAbove(T:z) ? get_step(T, UP) : null)
#define GET_BELOW(T) (HasBelow(T:z) ? get_step(T, DOWN) : null)

#define UPDATE_APPARENT(T, CH) T.apparent_##CH = T.self_##CH + T.below_##CH + T.ambient_##CH + T.above_ambient_##CH

/datum/lighting_corner/proc/init_ambient()
	var/sum_r = 0
	var/sum_g = 0
	var/sum_b = 0

	var/turf/T
	for (var/i in 1 to 4)
		// this is ugly as fuck, but it's still more legible than doing this with a macro
		switch (i)
			if (1) T = t1
			if (2) T = t2
			if (3) T = t3
			if (4) T = t4

		if (!T || !T.ambient_light)
			continue

		var/list/parts = rgb2num(T.ambient_light)

		sum_r += (parts[1] / 255) * T.ambient_light_multiplier
		sum_g += (parts[2] / 255) * T.ambient_light_multiplier
		sum_b += (parts[3] / 255) * T.ambient_light_multiplier

	sum_r /= 4
	sum_g /= 4
	sum_b /= 4

	update_ambient_lumcount(sum_r, sum_g, sum_b)

// God that was a mess, now to do the rest of the corner code! Hooray!
/datum/lighting_corner/proc/update_lumcount(delta_r, delta_g, delta_b, now = FALSE)
	if (!(delta_r + delta_g + delta_b))
		return

	self_r += delta_r
	self_g += delta_g
	self_b += delta_b

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	var/turf/T
	var/Ti
		// Grab the first master that's a Z-turf, if one exists.
	if ((T = t1?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t1i
	else if ((T = t2?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t2i
	else if ((T = t3?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t3i
	else if ((T = t4?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t4i
	else // Nothing above us that cares about below light.
		T = null

	if (TURF_IS_DYNAMICALLY_LIT(T))
		if (!T.corners || !T.corners[Ti])
			T.generate_missing_corners()
		var/datum/lighting_corner/above = T.corners[Ti]
		above.update_below_lumcount(delta_r, delta_g, delta_b, now)

	// This needs to be down here instead of the above if so the lum values are properly updated.
	if (needs_update)
		return

	if (now)
		update_overlays(TRUE)
	else
		needs_update = TRUE
		SSlighting.corner_queue += src

/datum/lighting_corner/proc/update_below_lumcount(delta_r, delta_g, delta_b, now = FALSE)
	if (!(delta_r + delta_g + delta_b))
		return

	below_r += delta_r
	below_g += delta_g
	below_b += delta_b

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	// This needs to be down here instead of the above if so the lum values are properly updated.
	if (needs_update)
		return

	if (!now)
		needs_update = TRUE
		SSlighting.corner_queue += src
	else
		update_overlays(TRUE)

//So, a turf with 4 corners needs to reset all 4 of those to 0, then we need to take turf below and tell its corners to rebuild
// Probably better ways to do this
/datum/lighting_corner/proc/clear_below_lumcount()

	if(!(below_r || below_b || below_g))
		return

	below_r = 0
	below_g = 0
	below_b = 0

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	if (needs_update)
		return

	needs_update = TRUE
	SSlighting.corner_queue += src

/datum/lighting_corner/proc/set_below_lumcount(_r, _g, _b)

	below_r = _r
	below_g = _g
	below_b = _b

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	if (needs_update)
		return

	needs_update = TRUE
	SSlighting.corner_queue += src

/datum/lighting_corner/proc/rebuild_above_below_lumcount()
	//Destroy current state and rebuild it!
	var/turf/T
	var/Ti
		// Grab the first master that's a Z-turf, if one exists.
	if ((T = t1?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t1i
	else if ((T = t2?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t2i
	else if ((T = t3?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t3i
	else if ((T = t4?.above) && (T.z_flags & ZM_ALLOW_LIGHTING))
		Ti = t4i
	else // Nothing above us that cares about below light.
		T = null

	if (TURF_IS_DYNAMICALLY_LIT(T))
		if (!T.corners || !T.corners[Ti])
			T.generate_missing_corners()
		var/datum/lighting_corner/above = T.corners[Ti]
		above.set_below_lumcount(self_r, self_g, self_b)

/datum/lighting_corner/proc/update_ambient_lumcount(delta_r, delta_g, delta_b, skip_update = FALSE)
	ambient_r += delta_r
	ambient_g += delta_g
	ambient_b += delta_b

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	var/turf/T
	var/Ti

	if (t1)
		T = t1
		Ti = t1i
	else if (t2)
		T = t2
		Ti = t2i
	else if (t3)
		T = t3
		Ti = t3i
	else if (t4)
		T = t4
		Ti = t4i
	else
		// This should be impossible to reach -- how do we exist without at least one master turf?
		CRASH("Corner has no masters!")

	var/datum/lighting_corner/below = src

	var/turf/lasT

	// We init before Z-Mimic, cannot rely on above/below.
	while ((lasT = T) && (T = T.below || GET_BELOW(T)) && (lasT.z_flags & ZM_ALLOW_LIGHTING) && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
		T.ambient_has_indirect = TRUE

		if (!T.corners || !T.corners[Ti])
			T.generate_missing_corners()

		ASSERT(length(T.corners))

		below = T.corners[Ti]
		below.above_ambient_r += delta_r
		below.above_ambient_g += delta_g
		below.above_ambient_b += delta_b

		UPDATE_APPARENT(below, r)
		UPDATE_APPARENT(below, g)
		UPDATE_APPARENT(below, b)

		if (!skip_update && !below.needs_update)
			below.needs_update = TRUE
			SSlighting.corner_queue += below

	if (needs_update || skip_update)
		return

	// Always queue for this, not important enough to hit the synchronous path.
	needs_update = TRUE
	SSlighting.corner_queue += src

/datum/lighting_corner/proc/clear_above_ambient()
	above_ambient_r = 0
	above_ambient_g = 0
	above_ambient_b = 0

	UPDATE_APPARENT(src, r)
	UPDATE_APPARENT(src, g)
	UPDATE_APPARENT(src, b)

	needs_update = TRUE
	SSlighting.corner_queue += src

#undef UPDATE_APPARENT

/datum/lighting_corner/proc/update_overlays(now = FALSE)
	var/lr = apparent_r
	var/lg = apparent_g
	var/lb = apparent_b

	// Cache these values a head of time so 4 individual lighting overlays don't all calculate them individually.
	var/mx = max(lr, lg, lb) // Scale it so 1 is the strongest lum, if it is above 1.
	. = 1 // factor
	if (mx > 1)
		. = 1 / mx

	cache_r = round(lr * ., LIGHTING_ROUND_VALUE)
	cache_g = round(lg * ., LIGHTING_ROUND_VALUE)
	cache_b = round(lb * ., LIGHTING_ROUND_VALUE)

	cache_mx = round(mx, LIGHTING_ROUND_VALUE)

	var/turf/T
	for (var/i in 1 to 4)
		// this is ugly as fuck, but it's still more legible than doing this with a macro
		switch (i)
			if (1) T = t1
			if (2) T = t2
			if (3) T = t3
			if (4) T = t4

		var/atom/movable/lighting_overlay/Ov
		if (T && (Ov = T.lighting_overlay))
			if (now)
				Ov.update_overlay()
			else if (!Ov.needs_update)
				Ov.needs_update = TRUE
				SSlighting.overlay_queue += Ov

/datum/lighting_corner/Destroy(force = FALSE)
	//PRINT_STACK_TRACE("Someone [force ? "force-" : ""]deleted a lighting corner.")
	if (!force)
		return QDEL_HINT_LETMELIVE

	SSlighting.total_lighting_corners -= 1
	return ..()

/datum/lighting_corner/dummy/New()
	return
