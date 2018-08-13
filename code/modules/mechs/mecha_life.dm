/mob/living/heavy_vehicle/handle_disabilities()
	return

/mob/living/heavy_vehicle/Life()

	// Size offsets for large mechs.
	if(offset_x && pixel_x != offset_x)
		pixel_x = offset_x
	if(offset_y && pixel_y != offset_y)
		pixel_y = offset_y

	if(pilot)

		if(pilot.loc != src) // Admin jump or teleport/grab.
			if(pilot.client)
				pilot.client.screen -= hud_elements
				pilot = null
				zone_sel = null
				a_intent = I_HURT
		else
			a_intent = pilot.a_intent
			zone_sel = pilot.zone_sel

		if(body.open_cabin)
			update_pilot_overlay()
			update_icon(1)

	body.update_air(hatch_closed)

	if((client || pilot) && body.cell)
		body.cell.use(calc_power_draw())

	updatehealth()
	if(health <= 0 && stat != DEAD)
		death()

	..()

	handle_hud_icons()

	lying = FALSE // Fuck off, carp.
	handle_vision()

/mob/living/heavy_vehicle/proc/calc_power_draw()
	// TODO
	// Count up hardpoints, charge them if necessary.
	// Count up body components that are pulling power, multiply by ratings.
	return 1

/mob/living/heavy_vehicle/death(var/gibbed)

	// Salvage moves into the wreck unless we're exploding violently.
	var/obj/wreck = new wreckage_path(get_turf(src))
	wreck.name = "wreckage of \the [name]"
	if(!gibbed)
		for(var/obj/item/thing in list(arms, legs, head, body))
			if(!thing) continue
			if(prob(40)) thing.forceMove(wreck)
		for(var/hardpoint in hardpoints)
			if(hardpoints[hardpoint] && prob(40))
				var/obj/item/thing = hardpoints[hardpoint]
				thing.forceMove(wreck)
				hardpoints[hardpoint] = null
		if(!(arms in src)) arms = null
		if(!(legs in src)) legs = null
		if(!(head in src)) head = null
		if(!(body in src)) body = null

	// Eject the pilot.
	if(pilot)
		hatch_locked = 0 // So they can get out.
		eject(pilot, silent=1)

	// Handle the rest of things.
	..(gibbed, (gibbed ? "explodes!" : "grinds to a halt before collapsing!"))
	if(!gibbed) qdel(src)

/mob/living/heavy_vehicle/gib()
	death(1)

	// Get a turf to play with.
	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	// Hurl our component pieces about.
	var/list/stuff_to_throw = list()
	for(var/obj/item/thing in list(arms, legs, head, body))
		if(thing) stuff_to_throw += thing
	for(var/hardpoint in hardpoints)
		if(hardpoints[hardpoint])
			var/obj/item/thing = hardpoints[hardpoint]
			thing.screen_loc = null
			stuff_to_throw += thing
	for(var/obj/item/thing in stuff_to_throw)
		thing.forceMove(T)
		thing.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(3,6),40)
	explosion(T, -1, 0, 2)
	qdel(src)
	return

/mob/living/heavy_vehicle/handle_vision()
	if(head && head.sight_flags)
		sight = head.sight_flags
