/var/total_lighting_overlays = 0
/atom/movable/lighting_overlay
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
	blend_mode = BLEND_MULTIPLY

	var/lum_r = 0
	var/lum_g = 0
	var/lum_b = 0

	var/needs_update = FALSE
	var/turf/myturf

/atom/movable/lighting_overlay/Initialize()
	// doesn't need special init
	initialized = TRUE
	return INITIALIZE_HINT_NORMAL

/atom/movable/lighting_overlay/New(var/atom/loc, var/no_update = FALSE)
	myturf = loc //If this runtimes atleast we'll know what's creating overlays outside of turfs.
	if(myturf.dynamic_lighting)
		. = ..()
		verbs.Cut()
		total_lighting_overlays++
		if (myturf.lighting_overlay)
			qdel(myturf.lighting_overlay)
		myturf.lighting_overlay = src
		myturf.luminosity = 0
		if(no_update)
			return
		update_overlay()
	else
		qdel(src)

/atom/movable/lighting_overlay/proc/update_overlay()
	set waitfor = FALSE
	if (loc != myturf || !isturf(loc))
		qdel(src, TRUE)
		return
/*
	if(!istype(T))
		if(loc)
			log_debug("A lighting overlay realised its loc was NOT a turf (actual loc: [loc][loc ? ", " + loc.type : "null"]) in update_overlay() and got qdel'ed!")
		else
			log_debug("A lighting overlay realised it was in nullspace in update_overlay() and got pooled!")
		qdel(src)
		return*/
	if(!myturf.dynamic_lighting)
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
	var/datum/lighting_corner/cr = myturf.corners[3] || dummy_lighting_corner
	var/datum/lighting_corner/cg = myturf.corners[2] || dummy_lighting_corner
	var/datum/lighting_corner/cb = myturf.corners[4] || dummy_lighting_corner
	var/datum/lighting_corner/ca = myturf.corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)

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

// Variety of overrides so the overlays don't get affected by weird things.
/atom/movable/lighting_overlay/ex_act()
	return

/atom/movable/lighting_overlay/singularity_pull()
	return

/atom/movable/lighting_overlay/Destroy()
	total_lighting_overlays--
	global.lighting_update_overlays     -= src
	global.lighting_update_overlays_old -= src

	if (loc != myturf)
		warning("A lighting object was qdeleted with a different loc then it is suppose to have (REDAC -> REDAC)")
	if (isturf(myturf))
		myturf.lighting_overlay = null
		myturf.luminosity = 1
	myturf = null

	return . = ..()

/atom/movable/lighting_overlay/forceMove()
	return 0 //should never move

/atom/movable/lighting_overlay/Move()
	return 0

/atom/movable/lighting_overlay/throw_at()
	return 0
