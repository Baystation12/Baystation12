/atom/movable/lighting_overlay
	name          = ""
	anchored      = TRUE
	icon          = LIGHTING_ICON
	icon_state    = LIGHTING_BASE_ICON_STATE
	color         = LIGHTING_BASE_MATRIX
	mouse_opacity = 0
	layer         = LIGHTING_LAYER
	plane         = LIGHTING_PLANE
	invisibility  = INVISIBILITY_LIGHTING
	simulated     = FALSE
	blend_mode    = BLEND_OVERLAY

	var/needs_update = FALSE
	var/safe_to_delete = FALSE
	var/new_lum = 0

	#if WORLD_ICON_SIZE != 32
	transform = matrix(WORLD_ICON_SIZE / 32, 0, (WORLD_ICON_SIZE - 32) / 2, 0, WORLD_ICON_SIZE / 32, (WORLD_ICON_SIZE - 32) / 2)
	#endif

/atom/movable/lighting_overlay/Initialize(mapload, update_now = FALSE)
	. = ..()
	atom_flags |= ATOM_FLAG_INITIALIZED
	SSlighting.total_lighting_overlays += 1

	var/turf/T         = loc // If this runtimes atleast we'll know what's creating overlays in things that aren't turfs.
	T.lighting_overlay = src
	T.luminosity       = 0

	if (T.corners && length(T.corners))
		for (var/datum/lighting_corner/C in T.corners)
			C.active = TRUE

	if (update_now)
		update_overlay()
		needs_update = FALSE
	else
		needs_update = TRUE
		SSlighting.overlay_queue += src

/atom/movable/lighting_overlay/Destroy()
	if (!safe_to_delete)
		return QDEL_HINT_LETMELIVE	// STOP DELETING ME

	SSlighting.total_lighting_overlays -= 1

	var/turf/T   = loc
	if (istype(T))
		T.lighting_overlay = null
		T.luminosity = 1

	return ..()

// This is a macro PURELY so that the if below is actually readable.
#define ALL_EQUAL ((rr == gr && gr == br && br == ar) && (rg == gg && gg == bg && bg == ag) && (rb == gb && gb == bb && bb == ab))

/atom/movable/lighting_overlay/proc/update_overlay()
	var/turf/T = loc
	if (!isturf(T)) // Erm...
		if (loc)
			warning("A lighting overlay realised its loc was NOT a turf (actual loc: [loc], [loc.type]) in update_overlay() and got deleted!")

		else
			warning("A lighting overlay realised it was in nullspace in update_overlay() and got deleted!")
		safe_to_delete = TRUE
		qdel(src)
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

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)
	new_lum = max > 0

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

	var/new_color

	if(rr + rg + rb + gr + gg + gb + br + bg + bb + ar + ag + ab >= 12)
		icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		color = null
	else if (rr == LIGHTING_DEFAULT_TUBE_R && rg == LIGHTING_DEFAULT_TUBE_G && rb == LIGHTING_DEFAULT_TUBE_B && ALL_EQUAL)
		icon_state = LIGHTING_STATION_ICON_STATE
		color = null
	else
		icon_state = LIGHTING_BASE_ICON_STATE

		// can't animate from null
		if(isnull(color))
			color = BLACKNESS_MATRIX
			// if we animate from blackness we wanna set luminosity now
			// so you can see the light overlay in the first place <3
			luminosity = new_lum

		if (islist(color))
			// Does this even save a list alloc?
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
			new_color = c_list
		else
			new_color = list(
				rr, rg, rb, 0,
				gr, gg, gb, 0,
				br, bg, bb, 0,
				ar, ag, ab, 0,
				0, 0, 0, 1
			)

	if(color != BLACKNESS_MATRIX)
		addtimer(new Callback(src, PROC_REF(update_luminosity)), LIGHTING_LIGHTSPEED)
	animate(src, color = new_color, time = LIGHTING_LIGHTSPEED)

	// If there's a Z-turf above us, update its shadower.
	if (T.above)
		if (T.above.shadower)
			T.above.shadower.copy_lighting(src)
		else
			T.above.update_mimic()

/atom/movable/lighting_overlay/proc/update_luminosity()
	luminosity = new_lum

	if (!luminosity)
		icon_state = LIGHTING_DARKNESS_ICON_STATE
		color = null

#undef ALL_EQUAL

// Variety of overrides so the overlays don't get affected by weird things.

/atom/movable/lighting_overlay/ex_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/atom/movable/lighting_overlay/singularity_act()
	return

/atom/movable/lighting_overlay/singularity_pull()
	return

/atom/movable/lighting_overlay/singuloCanEat()
	return FALSE

/atom/movable/lighting_overlay/can_fall()
	return FALSE

// Override here to prevent things accidentally moving around overlays.
/atom/movable/lighting_overlay/forceMove(atom/destination, harderforce = FALSE)
	if(QDELING(src))
		. = ..()
