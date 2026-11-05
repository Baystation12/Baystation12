/**
 * The physical tractor emitter: an 8x2 projector in the rig room
 *
 * The sprite is cut into 32px tiles in tractor_emitter.dmi
 *
 * The art has the barrel at the east end. Just map it with dir = WEST to mirror it so
 * the barrel is at the west end (and the beam fires west); it still takes up the
 * same 8x2 from its corner.
 */
/obj/machinery/tractor_emitter
	name = "tractor beam projector"
	desc = "A projector the length of a corridor: capacitor banks, a focusing train and a fat emitter barrel that throws a grappling beam into the space around the ship, and hauls whatever it catches in through the landing bay's intake."
	icon = 'icons/obj/machines/tractor_emitter.dmi'
	icon_state = "1-down"
	anchored = TRUE
	density = TRUE
	bound_width = 256
	bound_height = 64
	layer = ABOVE_OBJ_LAYER
	construct_state = /singleton/machine_construction/default/panel_closed
	base_type = /obj/machinery/tractor_emitter
	health_max = 400
	idle_power_usage = 2000
	active_power_usage = 60000
	light_color = "#9ff7e6"

	/// Claw stats, set in RefreshParts().
	/// How deep the claw can go, in pixels.
	var/reach_px = 0
	/// Total mass the claw can hold.
	var/capacity = 0
	/// Pixels the gantry moves per step.
	var/gantry_step = 8
	/// Deciseconds between casts.
	var/cooldown_time = 120
	/// How many overmap tiles out the field draws from, and how much the operator can identify (1 to 3).
	var/scan_tier = 0
	/// The beam it's firing into the landing bay's intake, while a haul comes aboard.
	var/obj/effect/tractor_projector_beam/beam
	/// Whether the claw is out: the muzzle glows while it is.
	var/casting = FALSE
	/// The glare at the muzzle, shown while casting or firing into the bay.
	var/obj/effect/tractor_projector_flare/flare


/obj/machinery/tractor_emitter/Destroy()
	QDEL_NULL(beam)
	if (flare)
		vis_contents -= flare
		QDEL_NULL(flare)
	return ..()


/// Width and height in tiles, and the tiles that have a glowing "-e" version.
#define TRACTOR_EMITTER_TILES_WIDE 8
#define TRACTOR_EMITTER_GLOW_TILES list("2-down", "3-down", "8-down", "8-up")


/obj/machinery/tractor_emitter/on_update_icon()
	ClearOverlays()
	for (var/column = 1 to TRACTOR_EMITTER_TILES_WIDE)
		for (var/row in list("down", "up"))
			var/state = "[column]-[row]"
			if (state == icon_state)
				continue
			var/image/tile = image(icon, state)
			tile.pixel_x = (column - 1) * world.icon_size
			tile.pixel_y = row == "up" ? world.icon_size : 0
			AddOverlays(tile)
	if (operable())
		for (var/state in TRACTOR_EMITTER_GLOW_TILES)
			var/column = text2num(copytext(state, 1, 2))
			var/offset_x = (column - 1) * world.icon_size
			var/offset_y = findtext(state, "-up") ? world.icon_size : 0
			var/image/glow = image(icon, "[state]-e")
			glow.pixel_x = offset_x
			glow.pixel_y = offset_y
			AddOverlays(glow)
			var/mutable_appearance/emissive = emissive_appearance(icon, "[state]-e")
			emissive.pixel_x = offset_x
			emissive.pixel_y = offset_y
			AddOverlays(emissive)
		set_light(2, 1.5)
	else
		set_light(0)
	update_flare()
	// Facing west, mirror the whole 8x2 sprite in place. Transforms work about the
	// middle of the 32px base tile, so it's flipped and then shifted back over its footprint.
	transform = dir == WEST ? matrix(-1, 0, bound_width - world.icon_size, 0, 1, 0) : null

#undef TRACTOR_EMITTER_TILES_WIDE
#undef TRACTOR_EMITTER_GLOW_TILES


/obj/machinery/tractor_emitter/power_change()
	. = ..()
	if (inoperable())
		casting = FALSE
		stop_beam()
	queue_icon_update()


/// Where the barrel's muzzle is, in pixels from the machine's bottom-left corner.
/obj/machinery/tractor_emitter/proc/muzzle_offset()
	return list(dir == WEST ? 0 : bound_width, world.icon_size)


/// Shows the muzzle flare while the claw is out or the beam is firing, and hides it otherwise.
/obj/machinery/tractor_emitter/proc/update_flare()
	var/want = operable() && (casting || beam)
	if (want && !flare)
		var/list/muzzle = muzzle_offset()
		flare = new(null)
		flare.pixel_x = muzzle[1] - world.icon_size / 2
		flare.pixel_y = muzzle[2] - world.icon_size / 2
		vis_contents += flare
	else if (!want && flare)
		vis_contents -= flare
		QDEL_NULL(flare)


/// Lights the muzzle while the claw is out.
/obj/machinery/tractor_emitter/proc/set_casting(state)
	if (casting == state)
		return
	casting = state
	queue_icon_update()


/**
 * Fires the beam level from the muzzle into the intake hatch while a haul comes
 * aboard, until stop_beam() (or `max_time`, in case nothing stops it).
 */
/obj/machinery/tractor_emitter/proc/start_beam(obj/machinery/tractor_intake/intake, max_time = 30 SECONDS)
	stop_beam()
	if (!intake || inoperable() || intake.z != z)
		return
	var/list/muzzle = muzzle_offset()
	var/list/mouth = intake.mouth_offset()
	var/target_x = (intake.x - x) * world.icon_size + world.icon_size / 2 + mouth[1]
	var/length = target_x - muzzle[1]
	if (!length)
		return
	beam = new(get_turf(src), muzzle[1], muzzle[2], length)
	update_flare()
	playsound(src, 'sound/weapons/emitter2.ogg', 60, TRUE)
	addtimer(new Callback(src, PROC_REF(stop_beam), beam), max_time)


/// Stops the beam. If `which` is given, only if that's still the current beam.
/obj/machinery/tractor_emitter/proc/stop_beam(obj/effect/tractor_projector_beam/which)
	if (!beam || (which && beam != which))
		return
	beam.fade()
	beam = null
	update_flare()


/**
 * The projector's beam across the landing bay, lots of filters onto a lousy sprite so by all means modify it
 */
/obj/effect/tractor_projector_beam
	name = "tractor beam"
	icon = null
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = BEAM_PROJECTILE_LAYER
	blend_mode = BLEND_ADD
	light_color = TRACTOR_COLOUR_FIELD
	alpha = 0
	/// 1 if the beam runs east from the muzzle, -1 if west.
	var/heading = 1
	/// Whether it's in its last-stretch surge.
	var/surging = FALSE


/obj/effect/tractor_projector_beam/Initialize(mapload, start_x, start_y, length)
	. = ..()
	heading = length > 0 ? 1 : -1
	var/segments = max(1, ceil(abs(length) / world.icon_size))
	for (var/i = 0 to segments - 1)
		var/segment_x = start_x + (heading > 0 ? i * world.icon_size : -(i + 1) * world.icon_size)
		// The sheath: the same segment, three times as tall and faint.
		var/image/sheath = image('icons/effects/tractor_bay.dmi', "projector_beam")
		sheath.pixel_x = segment_x
		sheath.pixel_y = start_y - world.icon_size / 2
		sheath.transform = matrix(heading, 0, 0, 0, 3, 0)
		sheath.alpha = 70
		AddOverlays(sheath)
		var/image/core = image('icons/effects/tractor_bay.dmi', "projector_beam")
		core.pixel_x = segment_x
		core.pixel_y = start_y - world.icon_size / 2
		if (heading < 0)
			core.transform = matrix(-1, 0, 0, 0, 1, 0)
		AddOverlays(core)

	filters += filter(type = "bloom", threshold = rgb(20, 40, 80), size = 3, offset = 1, alpha = 220)
	// A slow ripple along the beam. The wave's offset loops 0 to 1 for a seamless cycle.
	filters += filter(type = "wave", x = 48, y = 0, size = 1.2, offset = 0)
	animate(filters[2], offset = 1, time = 8, loop = -1)
	animate(offset = 0, time = 0)

	// Motes streaming down the beam into the intake. Particle positions are from the middle of the corner tile.
	var/particles/tractor_beam_motes/motes = new
	var/from_x = start_x - world.icon_size / 2
	var/to_x = from_x + length
	motes.position = generator("box", list(min(from_x, to_x), start_y - world.icon_size / 2 - 4), list(max(from_x, to_x), start_y - world.icon_size / 2 + 4))
	motes.velocity = generator("box", list(heading * 2, -0.3), list(heading * 5, 0.3))
	motes.width = abs(length) * 2 + 128
	motes.height = 128
	particles = motes

	set_light(3, 1)
	animate(src, alpha = 255, time = 3)
	animate(alpha = 215, time = 2, loop = -1)
	animate(alpha = 255, time = 2)


/**
 * The last stretch: the haul is coming through the hatch. The beam brightens and flickers fast,
 * its ripple races, and the motes pour down it several times as thick and quick, with a flash at
 * the muzzle as it kicks up.
 */
/obj/effect/tractor_projector_beam/proc/surge()
	if (surging || QDELETED(src))
		return
	surging = TRUE
	if (length(filters) >= 2)
		animate(filters[2], offset = 1, time = 2, loop = -1)
		animate(offset = 0, time = 0)
		animate(filters[2], size = 2.2, time = 4, flags = ANIMATION_PARALLEL)
	var/particles/tractor_beam_motes/motes = particles
	if (motes)
		motes.spawning = 14
		motes.count = 240
		motes.velocity = generator("box", list(heading * 6, -0.6), list(heading * 12, 0.6))
	set_light(4, 1.8)
	animate(src, alpha = 255, time = 1, loop = -1)
	animate(alpha = 175, time = 1)
	var/turf/T = get_turf(src)
	if (T)
		playsound(T, 'sound/weapons/emitter2.ogg', 70, TRUE)


/obj/effect/tractor_projector_beam/Destroy()
	QDEL_NULL(particles)
	return ..()


/obj/effect/tractor_projector_beam/proc/fade()
	if (particles)
		var/particles/tractor_beam_motes/motes = particles
		motes.spawning = 0
	animate(src, alpha = 0, time = 5)
	QDEL_IN(src, 6)


/particles/tractor_beam_motes
	icon = 'icons/effects/tractor_bay.dmi'
	icon_state = "bolt"
	count = 80
	spawning = 4
	lifespan = 8
	fade = 4
	scale = generator("num", 0.12, 0.3)
	color = generator("color", "#d8f2ff", "#2a82de")


/**
 * The glare at the projector's muzzle: a spinning, pulsing flare with its own
 * bloom, spraying sparks forward. Lives in the projector's vis_contents.
 */
/obj/effect/tractor_projector_flare
	name = ""
	icon = 'icons/effects/tractor_bay.dmi'
	icon_state = "projector_flare"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = BEAM_PROJECTILE_LAYER + 0.1
	blend_mode = BLEND_ADD


/obj/effect/tractor_projector_flare/Initialize()
	. = ..()
	filters += filter(type = "bloom", threshold = rgb(20, 40, 80), size = 4, offset = 2, alpha = 230)
	filters += filter(type = "drop_shadow", x = 0, y = 0, size = 8, offset = 3, color = "#2a82de90")
	particles = new /particles/tractor_muzzle_sparks
	var/matrix/small = matrix()
	small.Scale(0.9)
	var/matrix/big = matrix()
	big.Scale(1.4)
	big.Turn(45)
	var/matrix/back = matrix()
	back.Scale(0.9)
	back.Turn(90)
	transform = small
	animate(src, transform = big, time = 3, loop = -1, easing = SINE_EASING)
	animate(transform = back, time = 3, easing = SINE_EASING)


/obj/effect/tractor_projector_flare/Destroy()
	QDEL_NULL(particles)
	return ..()


/particles/tractor_muzzle_sparks
	icon = 'icons/effects/tractor_bay.dmi'
	icon_state = "bolt"
	width = 160
	height = 96
	count = 40
	spawning = 2
	lifespan = 6
	fade = 3
	velocity = generator("box", list(1.5, -1.5), list(4, 1.5))
	friction = 0.1
	scale = generator("num", 0.1, 0.25)
	color = generator("color", "#ffffff", "#70c8ff")


/obj/machinery/tractor_emitter/RefreshParts()
	..()
	var/manipulators = total_component_rating_of_type(/obj/item/stock_parts/manipulator)
	var/lasers = total_component_rating_of_type(/obj/item/stock_parts/micro_laser)
	var/bins = total_component_rating_of_type(/obj/item/stock_parts/matter_bin)
	var/capacitors = total_component_rating_of_type(/obj/item/stock_parts/capacitor)
	var/scanners = total_component_rating_of_type(/obj/item/stock_parts/scanning_module)

	gantry_step = 8 + manipulators * 4
	reach_px = lasers ? clamp(12 + lasers * 3, 12, TRACTOR_MAX_DEPTH_M) * TRACTOR_PX_PER_M : 0
	capacity = bins ? 2 + clamp(bins, 1, 3) * 2 : 0
	cooldown_time = max(3 SECONDS, 12 SECONDS - clamp(capacitors, 0, 3) * 3 SECONDS)
	scan_tier = clamp(scanners, 0, 3)


/// Returns why the emitter can't cast right now, or null if it can.
/obj/machinery/tractor_emitter/proc/cast_problem()
	if (inoperable())
		return "the projector has no power or is broken"
	if (!reach_px || !capacity)
		return "the projector is missing focusing lasers or a matter bin"
	if (!scan_tier)
		return "the projector has no scanning module"
	return null


/obj/item/stock_parts/circuitboard/tractor_emitter
	name = "circuit board (tractor beam projector)"
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/tractor_emitter
	origin_tech = list(TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 3)
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/scanning_module = 1
	)


/**
 * The tractor rig console. Opens the operator's minigame window.
 *
 * Links to the nearest tractor emitter within `link_range` tiles, and to the ship
 * it's on through the usual ship console linking.
 */
/obj/machinery/computer/ship/tractor_rig
	name = "tractor rig console"
	desc = "Controls a tractor beam emitter, for fishing salvage and ore out of the space around the ship."
	icon_keyboard = "rd_key"
	icon_screen = "teleport"
	light_color = "#4fd1c5"
	/// The emitter this console drives.
	var/obj/machinery/tractor_emitter/emitter
	/// The current operator's session, if any.
	var/datum/tractor_rig_session/session
	/// How far away the emitter can be.
	var/const/link_range = 10
	/// The area hauls land in when no intake is linked. With an intake, its area is the bay, so a rebuilt bay works whatever it's called.
	var/bay_area_type = /area/tractor_bay
	/// The landing bay's intake hatch.
	var/obj/machinery/tractor_intake/intake
	/// How far away the intake can be.
	var/const/intake_range = 30
	/// Whether striking a ship threat actually hurts the ship. Turn off for testing.
	var/ship_threats = TRUE
	/// world.time when the rig may next radio a collision alert. Keeps a run of strikes from flooding the channel.
	var/next_announcement = 0
	/// world.time the haul in transit lands, or 0 if nothing's in transit.
	var/arrival_due = 0
	/// id_tag of the blast doors over the rig's hull windows. The console drops them when the claw strikes a ship threat.
	var/shutter_tag = "tractor_rig_shutters"
	/// id_tag of the rotating alarms that show what the rig is doing.
	var/alarm_tag = "tractor_rig"
	/// What the alarms show when they aren't flashing something: a TRACTOR_ALARM_* mode.
	var/alarm_mode = TRACTOR_ALARM_OFF
	/// Bumped on every flash, so only the latest flash's timer puts the alarms back.
	var/alarm_flash_id = 0


/obj/machinery/computer/ship/tractor_rig/Initialize()
	. = ..()
	link_emitter()
	link_intake()


/obj/machinery/computer/ship/tractor_rig/Destroy()
	QDEL_NULL(session)
	unlink_emitter()
	unlink_intake()
	return ..()


/**
 * Links to an intake on this deck: one in the mapped bay area if there is one, otherwise the nearest
 * within `intake_range`. Called whenever the rig looks for its bay, so a rebuilt intake is picked up.
 */
/obj/machinery/computer/ship/tractor_rig/proc/link_intake()
	if (intake)
		return intake
	var/obj/machinery/tractor_intake/best
	var/best_dist = INFINITY
	for (var/obj/machinery/tractor_intake/candidate as anything in MACHINES_OF(/obj/machinery/tractor_intake))
		if (candidate.z != z)
			continue
		var/dist = get_dist(src, candidate)
		if (dist > intake_range)
			continue
		if (istype(get_area(candidate), bay_area_type))
			dist -= intake_range // the mapped bay wins
		if (dist < best_dist)
			best = candidate
			best_dist = dist
	if (best)
		intake = best
		GLOB.destroyed_event.register(intake, src, PROC_REF(unlink_intake))
	return intake


/obj/machinery/computer/ship/tractor_rig/proc/unlink_intake()
	if (intake)
		GLOB.destroyed_event.unregister(intake, src, PROC_REF(unlink_intake))
	intake = null


/obj/machinery/computer/ship/tractor_rig/proc/link_emitter()
	if (emitter)
		return emitter
	for (var/obj/machinery/tractor_emitter/candidate as anything in MACHINES_OF(/obj/machinery/tractor_emitter))
		if (candidate.z != z || get_dist(src, candidate) > link_range)
			continue
		emitter = candidate
		GLOB.destroyed_event.register(emitter, src, PROC_REF(unlink_emitter))
		return emitter


/obj/machinery/computer/ship/tractor_rig/proc/unlink_emitter()
	if (emitter)
		GLOB.destroyed_event.unregister(emitter, src, PROC_REF(unlink_emitter))
	emitter = null


/**
 * Returns why the console has no working link to its emitter, or null if the link
 * is up. The operator's window checks this every second and goes dark while it's set.
 */
/obj/machinery/computer/ship/tractor_rig/proc/link_problem()
	if (inoperable())
		return "the console has no power"
	if (!link_emitter())
		return "no projector within [link_range] metres"
	if (!emitter.is_powered())
		return "the projector has no power"
	if (emitter.inoperable())
		return "the projector is damaged"
	return null


/// Returns why a cast can't start right now, or null if it can.
/obj/machinery/computer/ship/tractor_rig/proc/cast_problem()
	if (inoperable())
		return "the console has no power"
	if (!link_emitter())
		return "no tractor projector within [link_range] metres"
	var/problem = emitter.cast_problem()
	if (problem)
		return problem
	if (linked && linked.get_speed() * 1000 > TRACTOR_MAX_LOCK_SPEED)
		return "the ship is moving too fast to hold a lock (over [TRACTOR_MAX_LOCK_SPEED] Gm/h)"
	if (arrival_due)
		return "the last haul is still materialising"
	var/area/bay = get_bay_area()
	if (!bay)
		return "no landing bay is mapped"
	var/obj/machinery/tractor_intake/intake = find_intake()
	if (intake && !intake.is_working())
		return "the landing bay's intake has no power"
	if (count_clear_bay_turfs() < TRACTOR_BAY_MIN_CLEAR)
		return "the landing bay is too cluttered (needs [TRACTOR_BAY_MIN_CLEAR] clear tiles)"
	return null


/obj/machinery/computer/ship/tractor_rig/proc/get_bay_area()
	RETURN_TYPE(/area)
	var/area/intake_area = get_area(link_intake())
	if (intake_area && !istype(intake_area, /area/space) && !(intake_area.area_flags & AREA_FLAG_EXTERNAL))
		return intake_area
	return locate(bay_area_type)


/obj/machinery/computer/ship/tractor_rig/proc/count_clear_bay_turfs()
	. = 0
	var/area/bay = get_bay_area()
	if (!bay)
		return
	for (var/turf/T as anything in get_area_turfs(bay))
		if (tractor_bay_turf_clear(T))
			.++


/// Warns everyone in the landing bay that a haul is about to materialise.
/obj/machinery/computer/ship/tractor_rig/proc/sound_bay_alarm(seconds)
	var/area/bay = get_bay_area()
	if (!bay)
		return
	for (var/mob/living/M in bay)
		to_chat(M, SPAN_DANGER("The landing bay klaxon blares: a tractor haul materialises in [seconds] seconds. Stand clear!"))
	var/list/turfs = get_area_turfs(bay)
	if (length(turfs))
		playsound(pick(turfs), 'sound/machines/warning-buzzer.ogg', 60, FALSE, 4)


/// The intake hatch in the landing bay, if one is mapped. TODO: We probably want to find one in the relevant area not first one we see
/obj/machinery/computer/ship/tractor_rig/proc/find_intake()
	RETURN_TYPE(/obj/machinery/tractor_intake)
	return link_intake()


/**
 * Fires the projector's beam into the intake while a loaded claw reels in, and holds it through
 * the trip to the bay: land_haul() makes it surge for the last stretch and finish_haul() stops it.
 */
/obj/machinery/computer/ship/tractor_rig/proc/start_haul_beam(reel_time)
	if (!emitter || emitter.beam)
		return
	var/obj/machinery/tractor_intake/intake = find_intake()
	if (intake)
		emitter.start_beam(intake, reel_time + TRACTOR_ARRIVAL_TIME + 30 SECONDS)


/// Drops the hauling beam when the claw comes back empty after all. Leaves it be if a haul is already on its way.
/obj/machinery/computer/ship/tractor_rig/proc/stop_haul_beam()
	if (!arrival_due)
		emitter?.stop_beam()


/obj/machinery/computer/ship/tractor_rig/proc/send_haul(list/singleton/tractor_contact/haul, mob/operator)
	arrival_due = world.time + TRACTOR_ARRIVAL_TIME
	sound_bay_alarm(TRACTOR_ARRIVAL_TIME / 10)
	var/obj/machinery/tractor_intake/intake = find_intake()
	intake?.warn()
	addtimer(new Callback(src, PROC_REF(land_haul), haul, operator), TRACTOR_ARRIVAL_TIME)


/// The haul is here: open the intake, then bring each payload through it.
/obj/machinery/computer/ship/tractor_rig/proc/land_haul(list/singleton/tractor_contact/haul, mob/operator)
	var/obj/machinery/tractor_intake/intake = find_intake()
	set_alarms(TRACTOR_ALARM_INBOUND)
	if (intake?.is_working())
		intake.cycle_open()
		// The beam's been holding the haul since the claw came home: now it surges to pull it through.
		if (emitter && !emitter.beam)
			emitter.start_beam(intake)
		emitter?.beam?.surge()
		addtimer(new Callback(src, PROC_REF(deliver_haul), haul, operator, intake), TRACTOR_INTAKE_OPEN_TIME)
	else
		deliver_haul(haul, operator, null)


/**
 * Lands a haul in the bay. Each payload claims the clear floor it needs straight
 * away (whatever doesn't fit is lost), then flies out of the intake to it.
 * Without an intake everything appears at once.
 */
/obj/machinery/computer/ship/tractor_rig/proc/deliver_haul(list/singleton/tractor_contact/haul, mob/operator, obj/machinery/tractor_intake/intake)
	var/list/landed = list()
	var/list/lost = list()
	var/area/bay_area = get_bay_area()
	var/datum/tractor_bay/bay = new(bay_area)
	if (QDELETED(intake))
		intake = null
	if (intake && bay_area)
		// The containment field ripples out across the bay from the hatch, in blue.
		for (var/turf/simulated/floor/T in get_area_turfs(bay_area))
			new /obj/effect/tractor_field(T, get_dist(T, intake) * TRACTOR_FIELD_RIPPLE, TRACTOR_PAYLOAD_STAGGER * length(haul) + 20)
	var/delay = 0
	var/last = 0
	for (var/singleton/tractor_contact/info as anything in haul)
		var/singleton/tractor_payload/payload = GET_SINGLETON(info.payload_type)
		var/list/turfs = payload ? payload.claim(bay) : list()
		if (!length(turfs))
			lost += info.name
			continue
		landed += info.name
		if (!intake)
			payload.materialise(turfs)
			land_flash(turfs)
			continue
		var/flight = 0
		for (var/turf/T as anything in turfs)
			flight = max(flight, max(4, round(get_dist(intake, T) * TRACTOR_FLIGHT_TIME_PER_TILE)))
		var/landing = delay + 2 + flight
		if (payload.flies_itself())
			// Made now, hidden, and flown out of the hatch.
			for (var/atom/movable/thing as anything in payload.materialise(turfs))
				intake.fly_in(thing, delay, flight)
			addtimer(new Callback(src, PROC_REF(land_flash), turfs), landing)
		else
			// A stand-in flies; the real thing appears when it lands.
			var/list/ghost = payload.ghost_appearance()
			if (ghost)
				for (var/turf/T as anything in turfs)
					new /obj/effect/tractor_ghost(T, intake, ghost[1], ghost[2], delay, flight)
			addtimer(new Callback(src, PROC_REF(materialise_payload), payload, turfs), landing)
		last = max(last, landing)
		delay += TRACTOR_PAYLOAD_STAGGER
	addtimer(new Callback(src, PROC_REF(finish_haul), landed, lost, operator, intake), last + 8)


/obj/machinery/computer/ship/tractor_rig/proc/materialise_payload(singleton/tractor_payload/payload, list/turf/turfs)
	payload.materialise(turfs)
	land_flash(turfs)


/// A ring of field energy and a thump where a payload has landed.
/obj/machinery/computer/ship/tractor_rig/proc/land_flash(list/turf/turfs)
	for (var/turf/T as anything in turfs)
		new /obj/effect/tractor_arrival(T)
	playsound(turfs[1], 'sound/effects/teleport.ogg', 40, TRUE)


/obj/machinery/computer/ship/tractor_rig/proc/finish_haul(list/landed, list/lost, mob/operator, obj/machinery/tractor_intake/intake)
	if (!QDELETED(intake))
		intake.cycle_close()
	emitter?.stop_beam()
	arrival_due = 0
	set_alarms(TRACTOR_ALARM_OFF)
	if (length(landed))
		flash_alarms(TRACTOR_ALARM_GOOD, 3 SECONDS)
	else if (length(lost))
		flash_alarms(TRACTOR_ALARM_DANGER, 3 SECONDS)
	log_and_message_admins("landed a tractor rig haul in [get_bay_area()]: [english_list(landed)][length(lost) ? ", lost [english_list(lost)]" : ""].", operator)
	session?.haul_landed(landed, lost)


/**
 * Hits the ship when the claw touches a ship threat: a meteor at the hull by the
 * emitter, an ion pulse, or carp at the hull outside.
 * todo, move some of this to the singletons
 */
/obj/machinery/computer/ship/tractor_rig/proc/strike_ship(singleton/tractor_contact/threat, mob/operator)
	if (!ship_threats || !emitter)
		return
	emergency_shutters()
	announce_threat(threat)
	var/turf/target = get_turf(emitter)
	log_and_message_admins("struck a ship threat ([threat.name]) with a tractor rig near [get_area(emitter)].", operator)
	switch (threat.type)
		if (/singleton/tractor_contact/meteor_big)
			var/turf/start = pick_space_near(target, 5, 9)
			if (!start)
				explosion(target, 2, EX_ACT_HEAVY)
				return
			var/obj/meteor/medium/rock = new(start)
			rock.dest = target
			walk_towards(rock, target, 3)
		if (/singleton/tractor_contact/ion_core)
			empulse(target, 2, 6, TRUE)
		if (/singleton/tractor_contact/carp_leader)
			for (var/i = 1 to 3)
				var/turf/spot = pick_space_near(target, 2, 6)
				if (spot)
					new /mob/living/simple_animal/hostile/carp(spot)


/**
 * Radios a collision alert to command, as the ship's own monitoring would, and to engineering
 * when there's damage to control.
 */
/obj/machinery/computer/ship/tractor_rig/proc/announce_threat(singleton/tractor_contact/threat)
	if (world.time < next_announcement)
		return
	next_announcement = world.time + 1 MINUTE
	var/area/where = get_area(emitter || src)
	var/place = where ? where.name : "the rig"
	var/hazard
	var/damage_control
	switch (threat.type)
		if (/singleton/tractor_contact/meteor_big)
			hazard = "a large meteor onto a collision course with the hull"
			damage_control = "Hull impact expected at [place]. Damage control teams stand by."
		if (/singleton/tractor_contact/ion_core)
			hazard = "a charged ion core against the hull. Expect an electromagnetic pulse"
			damage_control = "Ion discharge at [place]. Check electronics and power in the area."
		if (/singleton/tractor_contact/carp_leader)
			hazard = "a space carp school onto the hull. Expect hostile contacts outside"
		else
			hazard = "\a [threat.name] into the ship"
	GLOB.global_announcer.autosay("Collision alert. The tractor rig at [place] has drawn [hazard]. Emergency blast shutters are down at the rig.", "Tractor Rig Monitor", "Command")
	if (damage_control)
		GLOB.global_announcer.autosay(damage_control, "Tractor Rig Monitor", "Engineering")


/**
 * Drops the blast doors over the rig's hull windows (if any). Returns count.
 */
/obj/machinery/computer/ship/tractor_rig/proc/emergency_shutters()
	. = 0
	for (var/obj/machinery/door/blast/door in range(link_range, src))
		// Rebuilt shutters come without a tag: any in the rig room count.
		var/tagged = door.id_tag == shutter_tag || (!door.id_tag && get_area(door) == get_area(src))
		if (!tagged || door.density || door.operating)
			continue
		// force_close() sleeps through its animation, so run each on its own.
		addtimer(new Callback(door, TYPE_PROC_REF(/obj/machinery/door/blast, force_close)), 0)
		.++
	if (.)
		playsound(src, 'sound/machines/warning-buzzer.ogg', 50, FALSE)
		visible_message(SPAN_DANGER("\The [src] blares a collision warning as the emergency blast shutters slam down!"))


/// Sets what the rig's alarms show from now on (a TRACTOR_ALARM_* mode). A flash in progress finishes first.
/obj/machinery/computer/ship/tractor_rig/proc/set_alarms(mode)
	alarm_mode = mode
	if (!alarm_flash_id)
		show_alarms(mode)


/// Flashes the alarms green for good news or red for bad, for code outside the rig that doesn't know its alarm modes.
/obj/machinery/computer/ship/tractor_rig/proc/flash_outcome(good)
	flash_alarms(good ? TRACTOR_ALARM_GOOD : TRACTOR_ALARM_DANGER, good ? 3 SECONDS : 2 SECONDS)


/// Flashes the rig's alarms to `mode` for `time` deciseconds, then puts them back to what they were showing.
/obj/machinery/computer/ship/tractor_rig/proc/flash_alarms(mode, time)
	var/id = ++alarm_flash_id
	show_alarms(mode)
	addtimer(new Callback(src, PROC_REF(end_alarm_flash), id), time)


/obj/machinery/computer/ship/tractor_rig/proc/end_alarm_flash(id)
	if (id != alarm_flash_id)
		return
	alarm_flash_id = 0
	show_alarms(alarm_mode)


/obj/machinery/computer/ship/tractor_rig/proc/show_alarms(mode)
	for (var/obj/machinery/rotating_alarm/tractor_rig/alarm in range(link_range, src))
		if (alarm.id_tag == alarm_tag)
			alarm.show(mode)


/**
 * A rotating alarm wired to the tractor rig: amber while the claw is out, a green
 * flash for a clean catch, red for a hazard and red with a klaxon for a ship
 * threat, then blue while a haul comes aboard through the intake.
 */
/obj/machinery/rotating_alarm/tractor_rig
	name = "tractor rig alarm"
	desc = "A rotating alarm wired to the tractor rig. Amber while the claw is out, green for a clean catch, blue while a haul comes aboard, red when the claw stirs up something dangerous."
	id_tag = "tractor_rig"
	frame_type = /obj/item/frame/tractor_alarm
	construct_state = /singleton/machine_construction/default/item_chassis
	base_type = /obj/machinery/rotating_alarm/tractor_rig
	/// The TRACTOR_ALARM_* mode it's showing.
	var/mode = TRACTOR_ALARM_OFF
	/// Mode = list(light colour, hue rotation for the body, which is orange).
	var/static/list/looks = list(
		TRACTOR_ALARM_WORKING = list("#ffb000", 0),
		TRACTOR_ALARM_GOOD = list("#5dff92", 75),
		TRACTOR_ALARM_INBOUND = list("#70c8ff", 150),
		TRACTOR_ALARM_DANGER = list("#ff3b2a", -25),
		TRACTOR_ALARM_THREAT = list("#ff1a1a", -30)
	)


/obj/machinery/rotating_alarm/tractor_rig/proc/show(new_mode)
	if (new_mode == mode)
		return
	mode = new_mode
	if (sound_loop && new_mode != TRACTOR_ALARM_THREAT)
		QDEL_NULL(sound_loop)
	var/list/look = looks[new_mode]
	if (!look)
		set_off()
		color = null
		return
	color = color_rotation(look[2])
	set_color(look[1])
	if (on)
		set_light(2, 0.5, alarm_light_color)
	else
		set_on()
	if (new_mode == TRACTOR_ALARM_THREAT && !sound_loop)
		// The proximity alert klaxon, as the ship's own collision warnings use.
		sound_loop = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/effects/alert.ogg', 35, 7)


/// A space turf between `min_range` and `max_range` tiles from `centre`, or null.
/obj/machinery/computer/ship/tractor_rig/proc/pick_space_near(turf/centre, min_range, max_range)
	var/list/options = list()
	for (var/turf/space/T in range(max_range, centre))
		if (get_dist(T, centre) >= min_range)
			options += T
	return length(options) ? pick(options) : null


/obj/machinery/computer/ship/tractor_rig/interface_interact(mob/user)
	if (!user.client)
		return TRUE
	if (session && !QDELETED(session.user) && session.user != user)
		to_chat(user, SPAN_WARNING("\The [src] is already being operated by [session.user]."))
		return TRUE
	if (!linked)
		sync_linked()
	link_emitter()
	if (session)
		qdel(session)
	session = new /datum/tractor_rig_session(src, user)
	return TRUE


/obj/machinery/computer/ship/tractor_rig/OnTopic(mob/user, list/href_list)
	. = ..()
	if (. != TOPIC_NOACTION)
		return
	var/action = href_list["tractor_rig"]
	if (!action)
		return TOPIC_NOACTION
	if (!session || session.user != user)
		return TOPIC_HANDLED
	session.handle_action(action)
	return TOPIC_HANDLED


/obj/item/frame/tractor_alarm
	name = "tractor rig alarm frame"
	icon = 'icons/obj/structures/lighting.dmi'
	icon_state = "bulb-construct-item"
	refund_amt = 1
	build_machine_type = /obj/machinery/rotating_alarm/tractor_rig


/datum/stack_recipe/tractor_alarm
	title = "tractor rig alarm frame"
	result_type = /obj/item/frame/tractor_alarm
	req_amount = 1
	difficulty = 2


/datum/design/circuit/tractor_rig
	name = "tractor rig console"
	id = "tractor_rig"
	req_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	build_path = /obj/item/stock_parts/circuitboard/tractor_rig
	sort_string = "VAAAE"


/datum/design/circuit/tractor_emitter
	name = "tractor beam projector"
	id = "tractor_emitter"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MAGNET = 3, TECH_POWER = 3)
	build_path = /obj/item/stock_parts/circuitboard/tractor_emitter
	sort_string = "VAAAF"


/datum/design/circuit/tractor_intake
	name = "tractor intake"
	id = "tractor_intake"
	req_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	build_path = /obj/item/stock_parts/circuitboard/tractor_intake
	sort_string = "VAAAG"


/obj/item/stock_parts/circuitboard/tractor_rig
	name = "circuit board (tractor rig console)"
	build_path = /obj/machinery/computer/ship/tractor_rig
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2)
