/**
 * Hatch in the hull that the tractor beam
 * draws its catch in through. It never really opens to space; when a haul
 * arrives it opens up as a containment field, and each payload flies out
 *
 * Not actually necessary, it's just set dressing.
 */
/obj/machinery/tractor_intake
	name = "tractor intake"
	desc = "You can guess the severely worn warning on the panels says something along the lines of `keep clear`."
	icon = 'icons/obj/machines/tractor_intake.dmi'
	icon_state = "idle"
	dir = WEST
	anchored = TRUE
	density = FALSE
	layer = ABOVE_OBJ_LAYER
	/// Power is irrelevant, I just like the fantasy of it changing
	idle_power_usage = 50
	active_power_usage = 4 KILOWATTS
	construct_state = /singleton/machine_construction/default/panel_closed
	base_type = /obj/machinery/tractor_intake
	/// Whether the hatch is open or opening.
	var/cycling = FALSE


/obj/machinery/tractor_intake/Initialize(mapload)
	. = ..()
	if (!mapload)
		face_away_from_wall()
	place_art()
	update_icon()


/// Faces the hatch into the room, away from the first wall beside it.
/obj/machinery/tractor_intake/proc/face_away_from_wall()
	for (var/check_dir in list(EAST, WEST, NORTH, SOUTH))
		var/turf/T = get_step(src, check_dir)
		if (T?.density)
			set_dir(GLOB.reverse_dir[check_dir])
			return


/obj/item/stock_parts/circuitboard/tractor_intake
	name = "circuit board (tractor intake)"
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/tractor_intake
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/micro_laser = 1
	)


/obj/machinery/tractor_intake/set_dir(new_dir)
	. = ..()
	place_art()


/// Lines the 64x96 art up with the wall behind the hatch. Modify alongside offsets if art changes
/obj/machinery/tractor_intake/proc/place_art()
	var/matrix/M = matrix()
	switch (dir)
		if (EAST)
			M.Scale(-1, 1)
			pixel_x = -32
			pixel_y = -32
		if (NORTH)
			M.Turn(90)
			pixel_x = -16
			pixel_y = -48
		if (SOUTH)
			M.Turn(-90)
			pixel_x = -16
			pixel_y = -16
		else
			pixel_x = 0
			pixel_y = -32
	transform = M


/// Pixel offset, from this tile, of the middle of the hatch opening.
/obj/machinery/tractor_intake/proc/mouth_offset()
	var/list/step = list("[NORTH]" = list(0, -28), "[SOUTH]" = list(0, 28), "[EAST]" = list(-28, 0), "[WEST]" = list(28, 0))
	return step["[dir]"] || list(0, 0)


/obj/machinery/tractor_intake/on_update_icon()
	color = is_working() ? null : "#7a7a7a"
	if (cycling)
		return
	if (icon_state != "warn" || !is_working())
		icon_state = "idle"


/obj/machinery/tractor_intake/power_change()
	. = ..()
	update_icon()


/obj/machinery/tractor_intake/proc/is_working()
	return !inoperable()


/// Blinks the hatch's lamps amber while a haul is inbound.
/obj/machinery/tractor_intake/proc/warn()
	if (cycling || !is_working())
		return
	icon_state = "warn"


/// Opens onto the containment field. Takes TRACTOR_INTAKE_OPEN_TIME.
/obj/machinery/tractor_intake/proc/cycle_open()
	if (!is_working())
		return
	cycling = TRUE
	update_use_power(POWER_USE_ACTIVE)
	flick("opening", src)
	icon_state = "open"
	playsound(src, 'sound/machines/blastdoor_open.ogg', 60, TRUE)
	playsound(src, 'sound/machines/hiss.ogg', 40, TRUE)
	set_light(4, 0.8, TRACTOR_COLOUR_FIELD)


/obj/machinery/tractor_intake/proc/cycle_close()
	if (!cycling)
		return
	flick("closing", src)
	icon_state = "idle"
	cycling = FALSE
	update_use_power(POWER_USE_IDLE)
	playsound(src, 'sound/machines/blastdoor_close.ogg', 60, TRUE)
	set_light(0)
	update_icon()


/obj/machinery/tractor_intake/examine(mob/user, distance)
	. = ..()
	if (distance > 3)
		return
	if (!is_working())
		to_chat(user, SPAN_WARNING("Its status lamps are dark."))
	else if (cycling)
		to_chat(user, SPAN_WARNING("It's open, a green containment field shimmering where the hull should be. You probably shouldn't stand too close."))


/**
 * Makes `thing`, already on its landing turf, look like it flies out of the
 * intake's field: it starts small and tilted in the hatch mouth, wrapped in a
 * field glow, and settles into place `delay + flight` deciseconds from now.
 * It's invisible (and unclickable) until animation is done.
 */
/obj/machinery/tractor_intake/proc/fly_in(atom/movable/thing, delay, flight)
	var/turf/T = get_turf(thing)
	if (!T)
		return
	var/list/mouth = mouth_offset()
	var/end_x = thing.pixel_x
	var/end_y = thing.pixel_y
	var/end_alpha = thing.alpha
	var/matrix/end_transform = matrix(thing.transform)
	var/matrix/start_transform = matrix(thing.transform)
	start_transform.Scale(0.35)
	start_transform.Turn(pick(-45, 45))
	thing.pixel_x = end_x + (x - T.x) * world.icon_size + mouth[1]
	thing.pixel_y = end_y + (y - T.y) * world.icon_size + mouth[2]
	thing.transform = start_transform
	thing.alpha = 0
	var/glow = filter(type = "drop_shadow", x = 0, y = 0, size = 4, offset = 1, color = TRACTOR_COLOUR_FIELD)
	thing.filters += glow
	animate(thing, alpha = 0, time = delay)
	animate(alpha = end_alpha, time = 2)
	animate(pixel_x = end_x, pixel_y = end_y, transform = end_transform, time = flight, easing = QUAD_EASING | EASE_OUT)
	addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(tractor_unglow), thing, glow, end_x, end_y, end_alpha, end_transform), delay + 2 + flight + 3)


/proc/tractor_unglow(atom/movable/thing, glow, end_x, end_y, end_alpha, matrix/end_transform)
	if (QDELETED(thing))
		return
	thing.filters -= glow
	if (isnull(end_alpha))
		return
	animate(thing)
	thing.pixel_x = end_x
	thing.pixel_y = end_y
	thing.alpha = end_alpha
	thing.transform = end_transform


/**
 * A see-through stand-in for something that can't safely fly itself (a mob that
 * would act mid-air, or rock that's really a wall): it flies in, and the real
 * thing appears when it lands.
 */
/obj/effect/tractor_ghost
	name = ""
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/obj/effect/tractor_ghost/Initialize(mapload, obj/machinery/tractor_intake/intake, ghost_icon, ghost_state, delay, flight)
	. = ..()
	if (!intake || !ghost_icon)
		return INITIALIZE_HINT_QDEL
	icon = ghost_icon
	icon_state = ghost_state
	color = list(0.5, 0.6, 0.8, 0, 0.5, 0.6, 0.8, 0, 0.5, 0.6, 0.8, 0, 0, 0, 0, 1, 0.05, 0.15, 0.3, 0)
	alpha = 190
	intake.fly_in(src, delay, flight)
	QDEL_IN(src, delay + flight + 3)


/// One tile of the containment field rippling across the bay while the intake is open.
/obj/effect/tractor_field
	name = ""
	icon = 'icons/effects/tractor_bay.dmi'
	icon_state = "field"
	anchored = TRUE
	layer = ABOVE_HUMAN_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	alpha = 0


/obj/effect/tractor_field/Initialize(mapload, delay, hold)
	. = ..()
	animate(src, alpha = 0, time = delay)
	animate(alpha = 70, time = 3)
	animate(alpha = 40, time = hold)
	animate(alpha = 0, time = 6)
	QDEL_IN(src, delay + hold + 10)
