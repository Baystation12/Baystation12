/var/total_lightings = 0
/atom/movable/lighting
	name = ""
	mouse_opacity = 0
	simulated = 0
	anchored = 1
	icon = LIGHTING_ICON
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	invisibility = INVISIBILITY_LIGHTING
	color = LIGHTING_BASE_MATRIX
	icon_state = "light1"


	var/lum_r = 0
	var/lum_g = 0
	var/lum_b = 0

	var/needs_update = TRUE

/atom/movable/lighting/multiplier
	blend_mode = BLEND_MULTIPLY


/atom/movable/lighting/Initialize()
	// doesn't need special init
	initialized = TRUE
	return INITIALIZE_HINT_NORMAL

/atom/movable/lighting/multiplier/New(var/atom/loc, var/no_update = FALSE)
	var/turf/T = loc //If this runtimes atleast we'll know what's creating overlays outside of turfs.
	if(T.dynamic_lighting)
		. = ..()
		verbs.Cut()
		total_lightings++

		T.lighting_overlay = src
		T.luminosity = 0
		if(no_update)
			return
		update_overlay()
	else
		qdel(src)


/atom/movable/lighting/multiplier/Destroy(force = FALSE)
	if (!force)
		return QDEL_HINT_LETMELIVE	// STOP DELETING ME

	var/turf/T = loc
	if (istype(T))
		T.lighting_overlay = null
		T.luminosity = 1

	return ..()

/* Did I do a fucko?
/atom/movable/lighting/multiplier/proc/update_overlay()
	set waitfor = FALSE
	var/turf/T = loc

	if(!istype(T))
		if(loc)
			log_debug("A lighting overlay realised its loc was NOT a turf (actual loc: [loc][loc ? ", " + loc.type : "null"]) in update_overlay() and got qdel'ed!")
		else
			log_debug("A lighting overlay realised it was in nullspace in update_overlay() and got pooled!")
		qdel(src)
		return
	if(!T.dynamic_lighting)
		qdel(src)
		return

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	// No I seriously cannot think of a more efficient method, fuck off Comic.
	var/datum/lighting_corner/cr = T.corners[3] || dummy_lighting_corner
	var/datum/lighting_corner/cg = T.corners[2] || dummy_lighting_corner
	var/datum/lighting_corner/cb = T.corners[4] || dummy_lighting_corner
	var/datum/lighting_corner/ca = T.corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)


	if (!T.lighting_adder && (cr.needs_add || cg.needs_add || cb.needs_add || ca.needs_add))
		new /atom/movable/lighting/adder(loc)
	else if (T.lighting_adder)
		T.lighting_adder.update_overlay()

	var/rr = cr.cache_r
	var/rg = cr.cache_g
	var/rb = cr.cache_b

	var/gr = cg.cache_r
	var/gg = cg.cache_g
	var/gb = cg.cache_b

	var/br = cb.cache_r
	var/bg = cb.cache_g
	var/bb = cb.cache_b

	var/ar = ca.cache_r
	var/ag = ca.cache_g
	var/ab = ca.cache_b

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif

	if((rr & gr & br & ar) && (rg + gg + bg + ag + rb + gb + bb + ab == 8))
	//anything that passes the first case is very likely to pass the second, and addition is a little faster in this case
		icon_state = "transparent"
		color = null
	else if(!set_luminosity)
		icon_state = LIGHTING_ICON_STATE_DARK
		color = null
	else
		icon_state = null
		color = list(
			rr, rg, rb, 00,
			gr, gg, gb, 00,
			br, bg, bb, 00,
			ar, ag, ab, 00,
			00, 00, 00, 01
		)

	luminosity = set_luminosity

*/
// Variety of overrides so the overlays don't get affected by weird things.
/atom/movable/lighting/ex_act()
	return

/atom/movable/lighting/singularity_pull()
	return

/atom/movable/lighting/Destroy()
	total_lightings--
	global.lighting_update_overlays     -= src
	global.lighting_update_overlays_old -= src

	var/turf/T = loc
	if(istype(T))
		T.lighting_overlay = null

	. = ..()

/atom/movable/lighting/forceMove()
	return 0 //should never move

/atom/movable/lighting/Move()
	return 0

/atom/movable/lighting/throw_at()
	return 0

/atom/movable/lighting/adder
	blend_mode = BLEND_ADD

/atom/movable/lighting/adder/New()
	..()
	var/turf/T = loc
	T.lighting_adder = src

/atom/movable/lighting/adder/Destroy(force)
	if (!force)
		return QDEL_HINT_LETMELIVE	// feck off

	if (isturf(loc))
		var/turf/T = loc
		T.lighting_adder = null

	return ..()

// min(max((RL_LumR - 1) * 0.5, 0), 0.3)

/atom/movable/lighting/proc/update_overlay()
	var/turf/T = loc
	if (!istype(T)) // Erm...
		if (loc)
			warning("A lighting overlay realised its loc was NOT a turf (actual loc: [loc], [loc.type]) in update_overlay() and got deleted!")

		else
			warning("A lighting overlay realised it was in nullspace in update_overlay() and got deleted!")

		qdel(src, TRUE)
		return

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	var/list/corners = T.corners
	var/datum/lighting_corner/cr = dummy_lighting_corner
	var/datum/lighting_corner/cg = dummy_lighting_corner
	var/datum/lighting_corner/cb = dummy_lighting_corner
	var/datum/lighting_corner/ca = dummy_lighting_corner
	if (corners)
		cr = corners[3] || dummy_lighting_corner
		cg = corners[2] || dummy_lighting_corner
		cb = corners[4] || dummy_lighting_corner
		ca = corners[1] || dummy_lighting_corner

	var/visible = cr.needs_add || cg.needs_add || cb.needs_add || ca.needs_add

	if (visible)
		invisibility = INVISIBILITY_LIGHTING
		var/rr = cr.add_r
		var/rg = cr.add_g
		var/rb = cr.add_b

		var/gr = cg.add_r
		var/gg = cg.add_g
		var/gb = cg.add_b

		var/br = cb.add_r
		var/bg = cb.add_g
		var/bb = cb.add_b

		var/ar = ca.add_r
		var/ag = ca.add_g
		var/ab = ca.add_b

		if (islist(color))
			var/list/c_list = color
			c_list[CL_MATRIX_RR] = rr
			c_list[CL_MATRIX_RG] = rg
			c_list[CL_MATRIX_RB] = rb
			c_list[CL_MATRIX_GR] = gr
			c_list[CL_MATRIX_GG] = gg
			c_list[CL_MATRIX_GB] = gb
			c_list[CL_MATRIX_BR] = br
			c_list[CL_MATRIX_BG] = bg
			c_list[CL_MATRIX_BB] = bb
			c_list[CL_MATRIX_AR] = ar
			c_list[CL_MATRIX_AG] = ag
			c_list[CL_MATRIX_AB] = ab
			color = c_list
		else
			color = list(
				rr, rg, rb, 0,
				gr, gg, gb, 0,
				br, bg, bb, 0,
				ar, ag, ab, 0,
				0, 0, 0, 1
			)
	else
		qdel(src, TRUE)
