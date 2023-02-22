// This is where the fun begins.
// These are the main datums that emit light.

/datum/light_source
	var/atom/top_atom        // The atom we're emitting light from (for example a mob if we're from a flashlight that's being held).
	var/atom/source_atom     // The atom that we belong to.

	var/turf/source_turf // The turf under the above.
	var/turf/pixel_turf  // The turf the top_atom _appears_ to be on
	var/light_power      // Intensity of the emitter light.
	var/light_range      // The range of the emitted light.
	var/light_color      // The colour of the light, string, decomposed by parse_light_color()
	var/light_angle      // The light's emission angle, in degrees.

	// Variables for keeping track of the colour.
	var/lum_r
	var/lum_g
	var/lum_b

	// The lumcount values used to apply the light.
	var/applied_lum_r
	var/applied_lum_g
	var/applied_lum_b

	// Variables used to keep track of the atom's angle.
	var/limit_a_x       // The first test point's X coord for the cone.
	var/limit_a_y       // The first test point's Y coord for the cone.
	var/limit_b_x       // The second test point's X coord for the cone.
	var/limit_b_y       // The second test point's Y coord for the cone.
	var/cached_origin_x // The last known X coord of the origin.
	var/cached_origin_y // The last known Y coord of the origin.
	var/old_direction   // The last known direction of the origin.
	var/test_x_offset   // How much the X coord should be offset due to direction.
	var/test_y_offset   // How much the Y coord should be offset due to direction.
	var/facing_opaque = FALSE

	var/list/datum/lighting_corner/effect_str     // List used to store how much we're affecting corners.
	var/list/turf/affecting_turfs

	var/applied = FALSE // Whether we have applied our light yet or not.

	var/needs_update = LIGHTING_NO_UPDATE

// This macro will only offset up to 1 tile, but anything with a greater offset is an outlier and probably should handle its own lighting offsets.
// Anything pixelshifted 16px or more will be considered on the next tile.
#define GET_APPROXIMATE_PIXEL_DIR(PX, PY) ((!(PX) ? 0 : (((PX) >= 16 ? EAST : ((PX) <= -16 ? WEST : 0)))) | (!(PY) ? 0 : ((PY) >= 16 ? NORTH : ((PY) <= -16 ? SOUTH : 0))))
#define UPDATE_APPROXIMATE_PIXEL_TURF var/px = top_atom.light_offset_x || top_atom.pixel_x; var/py = top_atom.light_offset_y || top_atom.pixel_y; var/_dir = GET_APPROXIMATE_PIXEL_DIR(px, py); pixel_turf = _dir ? (get_step(source_turf, _dir) || source_turf) : source_turf

// These macros are for dealing with the multi/solo split.
#define ADD_SOURCE(TARGET) if (!TARGET.light_source_multi && !TARGET.light_source_solo) { TARGET.light_source_solo = src; } else if (TARGET.light_source_solo) { TARGET.light_source_multi = list(TARGET.light_source_solo, src); TARGET.light_source_solo = null; } else { TARGET.light_source_multi += src }
#define REMOVE_SOURCE(TARGET) if (TARGET.light_source_solo == src) { TARGET.light_source_solo = null } else if (TARGET.light_source_multi) { TARGET.light_source_multi -= src; if (length(TARGET.light_source_multi) == 1) { TARGET.light_source_solo = TARGET.light_source_multi[1]; TARGET.light_source_multi = null; } }

/datum/light_source/New(atom/owner, atom/top)
	SSlighting.total_lighting_sources += 1
	source_atom = owner // Set our new owner.

	ADD_SOURCE(source_atom)

	top_atom = top
	if (top_atom != source_atom)
		ADD_SOURCE(top_atom)

	source_turf = top_atom
	UPDATE_APPROXIMATE_PIXEL_TURF
	light_power = source_atom.light_power
	light_range = source_atom.light_range
	light_color = source_atom.light_color
	light_angle = source_atom.light_wedge

	parse_light_color()

	update()

// Kill ourselves.
/datum/light_source/Destroy(force)
	SSlighting.total_lighting_sources -= 1

	remove_lum()
	if (source_atom)
		REMOVE_SOURCE(source_atom)

	if (top_atom)
		REMOVE_SOURCE(top_atom)

	. = ..()
	if (!force)
		return QDEL_HINT_IWILLGC

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
// Picks either scheduled or instant updates based on current server load.
#define INTELLIGENT_UPDATE(level)                      \
	var/_should_update = needs_update == LIGHTING_NO_UPDATE; \
	if (needs_update < level) {                        \
		needs_update = level;                          \
	}                                                  \
	if (_should_update) {                              \
		if (world.tick_usage > (Master.current_ticklimit/2) || light_range > LIGHTING_MAXIMUM_INSTANT_RANGE || SSlighting.force_queued) {	\
			SSlighting.light_queue += src;              \
		}                                               \
		else {                                          \
			SSlighting.total_instant_updates += 1;      \
			update_corners(TRUE);                       \
			needs_update = LIGHTING_NO_UPDATE;          \
		}                                               \
	}
#else
#define INTELLIGENT_UPDATE(level)           \
	if (needs_update == LIGHTING_NO_UPDATE) \
		SSlighting.light_queue += src;      \
	if (needs_update < level)               \
		needs_update = level;
#endif

// This proc will cause the light source to update the top atom, and add itself to the update queue.
/datum/light_source/proc/update(atom/new_top_atom)
	// This top atom is different.
	if (new_top_atom && new_top_atom != top_atom)
		if(top_atom != source_atom) // Remove ourselves from the light sources of that top atom.
			REMOVE_SOURCE(top_atom)

		top_atom = new_top_atom

		if (top_atom != source_atom)
			ADD_SOURCE(top_atom)	// Add ourselves to the light sources of our new top atom.

	INTELLIGENT_UPDATE(LIGHTING_CHECK_UPDATE)

// Will force an update without checking if it's actually needed.
/datum/light_source/proc/force_update()
	INTELLIGENT_UPDATE(LIGHTING_FORCE_UPDATE)

// Will cause the light source to recalculate turfs that were removed or added to visibility only.
/datum/light_source/proc/vis_update()
	INTELLIGENT_UPDATE(LIGHTING_VIS_UPDATE)

// Decompile the hexadecimal colour into lumcounts of each perspective.
/datum/light_source/proc/parse_light_color()
	if (light_color)
		var/list/parts = rgb2num(light_color)
		ASSERT(length(parts) == 3)
		lum_r = parts[1] / 255
		lum_g = parts[2] / 255
		lum_b = parts[3] / 255
	else
		lum_r = 1
		lum_g = 1
		lum_b = 1

#define POLAR_TO_CART_X(R,T) ((R) * cos(T))
#define POLAR_TO_CART_Y(R,T) ((R) * sin(T))
#define DETERMINANT(A_X,A_Y,B_X,B_Y) ((A_X)*(B_Y) - (A_Y)*(B_X))
#define MINMAX(NUM) ((NUM) < 0 ? -round(-(NUM)) : round(NUM))
#define ARBITRARY_NUMBER 10

/datum/light_source/proc/regenerate_angle(ndir)
	old_direction = ndir

	var/turf/front = get_step(source_turf, old_direction)
	facing_opaque = (front && front.has_opaque_atom)

	cached_origin_x = test_x_offset = source_turf.x
	cached_origin_y = test_y_offset = source_turf.y

	if (facing_opaque)
		return

	var/limit_a_t
	var/limit_b_t

	var/angle = light_angle * 0.5
	switch (old_direction)
		if (NORTH)
			limit_a_t = angle + 90
			limit_b_t = -(angle) + 90
			test_y_offset += 1

		if (SOUTH)
			limit_a_t = (angle) - 90
			limit_b_t = -(angle) - 90
			test_y_offset -= 1

		if (EAST)
			limit_a_t = angle
			limit_b_t = -(angle)
			test_x_offset += 1

		if (WEST)
			limit_a_t = angle + 180
			limit_b_t = -(angle) - 180
			test_x_offset -= 1

	// Convert our angle + range into a vector.
	limit_a_x = POLAR_TO_CART_X(light_range + ARBITRARY_NUMBER, limit_a_t)
	limit_a_x = MINMAX(limit_a_x)
	limit_a_y = POLAR_TO_CART_Y(light_range + ARBITRARY_NUMBER, limit_a_t)
	limit_a_y = MINMAX(limit_a_y)
	limit_b_x = POLAR_TO_CART_X(light_range + ARBITRARY_NUMBER, limit_b_t)
	limit_b_x = MINMAX(limit_b_x)
	limit_b_y = POLAR_TO_CART_Y(light_range + ARBITRARY_NUMBER, limit_b_t)
	limit_b_y = MINMAX(limit_b_y)

#undef ARBITRARY_NUMBER
#undef POLAR_TO_CART_X
#undef POLAR_TO_CART_Y
#undef MINMAX

/datum/light_source/proc/remove_lum(now = FALSE)
	applied = FALSE

	var/thing
	for (thing in affecting_turfs)
		var/turf/T = thing
		LAZYREMOVE(T.affecting_lights, src)

	affecting_turfs = null

	for (thing in effect_str)
		var/datum/lighting_corner/C = thing
		REMOVE_CORNER(C,now)

		LAZYREMOVE(C.affecting, src)

	effect_str = null

/datum/light_source/proc/recalc_corner(datum/lighting_corner/C, now = FALSE)
	LAZYINITLIST(effect_str)
	if (effect_str[C]) // Already have one.
		REMOVE_CORNER(C,now)
		effect_str[C] = 0

	var/actual_range = light_range

	var/Sx = pixel_turf.x
	var/Sy = pixel_turf.y
	var/Sz = pixel_turf.z

	var/height = C.z == Sz ? LIGHTING_HEIGHT : CALCULATE_CORNER_HEIGHT(C.z, Sz)
	APPLY_CORNER(C, now, Sx, Sy, height)

	UNSETEMPTY(effect_str)

/datum/light_source/proc/update_corners(now = FALSE)
	var/update = FALSE

	if (QDELETED(source_atom))
		qdel(src)
		return

	if (source_atom.light_power != light_power)
		light_power = source_atom.light_power
		update = TRUE

	if (source_atom.light_range != light_range)
		light_range = source_atom.light_range
		update = TRUE

	if (!top_atom)
		top_atom = source_atom
		update = TRUE

	if (top_atom.loc != source_turf)
		source_turf = top_atom.loc
		UPDATE_APPROXIMATE_PIXEL_TURF
		update = TRUE

	if (!light_range || !light_power)
		qdel(src)
		return

	if (isturf(top_atom))
		if (source_turf != top_atom)
			source_turf = top_atom
			UPDATE_APPROXIMATE_PIXEL_TURF
			update = TRUE
	else if (top_atom.loc != source_turf)
		source_turf = top_atom.loc
		UPDATE_APPROXIMATE_PIXEL_TURF
		update = TRUE

	if (!source_turf)
		return	// Somehow we've got a light in nullspace, no-op.

	if (light_range && light_power && !applied)
		update = TRUE

	if (source_atom.light_color != light_color)
		light_color = source_atom.light_color
		parse_light_color()
		update = TRUE

	else if (applied_lum_r != lum_r || applied_lum_g != lum_g || applied_lum_b != lum_b)
		update = TRUE

	if (source_atom.light_wedge != light_angle)
		light_angle = source_atom.light_wedge
		update = TRUE

	if (light_angle)
		var/ndir
		if (istype(top_atom, /mob) && top_atom:facing_dir)
			ndir = top_atom:facing_dir
		else
			ndir = top_atom.dir

		if (old_direction != ndir)	// If our direction has changed, we need to regenerate all the angle info.
			regenerate_angle(ndir)
			update = TRUE
		else // Check if it was just a x/y translation, and update our vars without an regenerate_angle() call if it is.
			var/co_updated = FALSE
			if (source_turf.x != cached_origin_x)
				test_x_offset += source_turf.x - cached_origin_x
				cached_origin_x = source_turf.x

				co_updated = TRUE

			if (source_turf.y != cached_origin_y)
				test_y_offset += source_turf.y - cached_origin_y
				cached_origin_y = source_turf.y

				co_updated = TRUE

			if (co_updated)
				// We might be facing a wall now.
				var/turf/front = get_step(source_turf, old_direction)
				var/new_fo = (front && front.has_opaque_atom)
				if (new_fo != facing_opaque)
					facing_opaque = new_fo
					regenerate_angle(ndir)

				update = TRUE

	if (update)
		needs_update = LIGHTING_CHECK_UPDATE
	else if (needs_update == LIGHTING_CHECK_UPDATE)
		return	// No change.

	var/list/datum/lighting_corner/corners = list()
	var/list/turf/turfs                    = list()
	var/thing
	var/datum/lighting_corner/C
	var/turf/T
	var/list/Tcorners
	var/Sx = pixel_turf.x	// these are used by APPLY_CORNER_BY_HEIGHT
	var/Sy = pixel_turf.y
	var/Sz = pixel_turf.z
	var/corner_height = LIGHTING_HEIGHT
	var/actual_range = (light_angle && facing_opaque) ? light_range * LIGHTING_BLOCKED_FACTOR : light_range
	var/test_x
	var/test_y

	var/should_do_wedge = light_angle && !facing_opaque

	FOR_DVIEW(T, Ceilm(actual_range, 1), source_turf, 0) do
		if (should_do_wedge)	// Directional lighting coordinate filter.
			test_x = T.x - test_x_offset
			test_y = T.y - test_y_offset

			// If the signs of these are the same, then the point is within the cone.
			if ((DETERMINANT(limit_a_x, limit_a_y, test_x, test_y) > 0) || DETERMINANT(test_x, test_y, limit_b_x, limit_b_y) > 0)
				continue

		if (TURF_IS_DYNAMICALLY_LIT_UNSAFE(T) || T.light_source_solo || T.light_source_multi)
			Tcorners = T.corners
			if (!T.lighting_corners_initialised)
				T.lighting_corners_initialised = TRUE

				if (!Tcorners)
					T.corners = list(null, null, null, null)
					Tcorners = T.corners

				for (var/i = 1 to 4)
					if (Tcorners[i])
						continue

					Tcorners[i] = new /datum/lighting_corner(T, LIGHTING_CORNER_DIAGONAL[i], i)

			if (!T.has_opaque_atom)
				for (var/v in 1 to 4)
					var/val = Tcorners[v]
					if (val)
						corners[val] = 0

		turfs += T

	// Upwards lights are handled at the corner level, so only search down.
	//  This is a do-while associated with the FOR_DVIEW above.
	while (T && (T.z_flags & ZM_ALLOW_LIGHTING) && (T = T.below))
	END_FOR_DVIEW

	LAZYINITLIST(affecting_turfs)

	var/list/L = turfs - affecting_turfs // New turfs, add us to the affecting lights of them.
	affecting_turfs += L
	for (thing in L)
		T = thing
		LAZYADD(T.affecting_lights, src)

	L = affecting_turfs - turfs // Now-gone turfs, remove us from the affecting lights.
	affecting_turfs -= L
	for (thing in L)
		T = thing
		LAZYREMOVE(T.affecting_lights, src)

	LAZYINITLIST(effect_str)
	if (needs_update == LIGHTING_VIS_UPDATE)
		for (thing in corners - effect_str)
			C = thing
			LAZYADD(C.affecting, src)
			if (!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER_BY_HEIGHT(now)
	else
		L = corners - effect_str
		for (thing in L)
			C = thing
			LAZYADD(C.affecting, src)
			if (!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER_BY_HEIGHT(now)

		for (thing in corners - L)
			C = thing
			if (!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER_BY_HEIGHT(now)

	L = effect_str - corners
	for (thing in L)
		C = thing
		REMOVE_CORNER(C, now)
		LAZYREMOVE(C.affecting, src)

	effect_str -= L

	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

	UNSETEMPTY(effect_str)
	UNSETEMPTY(affecting_turfs)

#undef INTELLIGENT_UPDATE
#undef DETERMINANT
#undef GET_APPROXIMATE_PIXEL_DIR
#undef UPDATE_APPROXIMATE_PIXEL_TURF
