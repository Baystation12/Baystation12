/mob/living/exosuit/handle_disabilities()
	return

/mob/living/exosuit/Life()

	for(var/thing in pilots)
		var/mob/pilot = thing
		if(pilot.loc != src) // Admin jump or teleport/grab.
			if(pilot.client)
				pilot.client.screen -= hud_elements
				LAZYREMOVE(pilots, pilot)
				UNSETEMPTY(pilots)
		update_pilots()

	if(radio)
		radio.on = (head && head.radio && head.radio.is_functional() && get_cell())

	body.update_air(hatch_closed && use_air)

	var/powered = FALSE
	if(get_cell())
		powered = get_cell().drain_power(0, 0, calc_power_draw()) > 0

	if(!powered)
		//Shut down all systems
		if(head)
			head.active_sensors = FALSE
			hud_camera.queue_icon_update()
		for(var/hardpoint in hardpoints)
			var/obj/item/mech_equipment/M = hardpoints[hardpoint]
			if(istype(M) && M.active && M.passive_power_use)
				M.deactivate()


	updatehealth()
	if(health <= 0 && stat != DEAD)
		death()

	if(emp_damage > 0)
		emp_damage -= min(1, emp_damage) //Reduce emp accumulation over time

	..() //Handles stuff like environment

	handle_hud_icons()

	lying = FALSE // Fuck off, carp.
	handle_vision(powered)

/mob/living/exosuit/get_cell(force)
	RETURN_TYPE(/obj/item/cell)
	if(power == MECH_POWER_ON || force) //For most intents we can assume that a powered off exosuit acts as if it lacked a cell
		return body ? body.cell : null
	return null

/mob/living/exosuit/proc/calc_power_draw()
	//Passive power stuff here. You can also recharge cells or hardpoints if those make sense
	var/total_draw = 0
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_equipment/I = hardpoints[hardpoint]
		if(!istype(I))
			continue
		total_draw += I.passive_power_use

	if(head && head.active_sensors)
		total_draw += head.power_use

	if(body)
		total_draw += body.power_use

	return total_draw

/mob/living/exosuit/handle_environment(var/datum/gas_mixture/environment)
	if(!environment) return
	//Mechs and vehicles in general can be assumed to just tend to whatever ambient temperature
	if(abs(environment.temperature - bodytemperature) > 0 )
		bodytemperature += ((environment.temperature - bodytemperature) / 6)

	if(bodytemperature > material.melting_point * 1.45 ) //A bit higher because I like to assume there's a difference between a mech and a wall
		var/damage = 5
		if(bodytemperature > material.melting_point * 1.75 )
			damage = 10
		if(bodytemperature > material.melting_point * 2.15 )
			damage = 15
		apply_damage(damage, DAMAGE_BURN)
	//A possibility is to hook up interface icons here. But this works pretty well in my experience
		if(prob(damage))
			visible_message(SPAN_DANGER("\The [src]'s hull bends and buckles under the intense heat!"))

	hud_heat.Update()

/mob/living/exosuit/death(var/gibbed)
	// Eject the pilot.
	if(LAZYLEN(pilots))
		hatch_locked = 0 // So they can get out.
		for(var/pilot in pilots)
			eject(pilot, silent=1)

	// Salvage moves into the wreck unless we're exploding violently.
	var/obj/wreck = new wreckage_path(get_turf(src), src, gibbed)
	wreck.name = "wreckage of \the [name]"
	if(!gibbed)
		if(arms.loc != src)
			arms = null
		if(legs.loc != src)
			legs = null
		if(head.loc != src)
			head = null
		if(body.loc != src)
			body = null

	// Handle the rest of things.
	..(gibbed, (gibbed ? "explodes!" : "grinds to a halt before collapsing!"))
	if(!gibbed) qdel(src)

/mob/living/exosuit/gib()
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

/mob/living/exosuit/handle_vision(powered)
	var/was_blind = sight & BLIND
	if(head)
		sight = head.get_sight(powered)
		see_invisible = head.get_invisible(powered)
	if(body && (body.pilot_coverage < 100 || body.transparent_cabin) || !hatch_closed)
		sight &= ~BLIND

	if(sight & BLIND && !was_blind)
		for(var/mob/pilot in pilots)
			to_chat(pilot, SPAN_WARNING("The sensors are not operational and you cannot see a thing!"))

/mob/living/exosuit/additional_sight_flags()
	return sight

/mob/living/exosuit/additional_see_invisible()
	return see_invisible
