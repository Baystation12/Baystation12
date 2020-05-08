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
		radio.on = (head && head.radio && head.radio.is_functional())

	body.update_air(hatch_closed && use_air)

	if((client || LAZYLEN(pilots)) && get_cell())
		get_cell().drain_power(0, 0, calc_power_draw())

	updatehealth()
	if(health <= 0 && stat != DEAD)
		death()

	..() //Handles stuff like environment

	handle_mutations_and_radiation()

	handle_hud_icons()

	lying = FALSE // Fuck off, carp.
	handle_vision()

/mob/living/exosuit/handle_mutations_and_radiation()
	radiation = Clamp(radiation,0,500) //Dont let exosuits accumulate radiation

	if(radiation)
		radiation--
	
/mob/living/exosuit/get_cell()
	RETURN_TYPE(/obj/item/weapon/cell)
	return body ? body.cell : null

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
	if(abs(environment.temperature - bodytemperature) > 10 )
		bodytemperature += ((environment.temperature - bodytemperature) / 3)

	if(environment.temperature > material.melting_point * 1.25 ) //A bit higher because I like to assume there's a difference between a mech and a wall
		apply_damage(damage = (environment.temperature - (material.melting_point))/5 , damagetype = BURN)
	//A possibility is to hook up interface icons here. But this works pretty well in my experience
		if(prob(5))
			visible_message(SPAN_DANGER("\The [src]'s hull bends and buckles under the intense heat!"))
			

/mob/living/exosuit/death(var/gibbed)

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

	// Eject the pilot.
	if(LAZYLEN(pilots))
		hatch_locked = 0 // So they can get out.
		for(var/pilot in pilots)
			eject(pilot, silent=1)

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

/mob/living/exosuit/handle_vision()
	if(head)
		sight = head.get_sight()
		see_invisible = head.get_invisible()
	if(body && (body.pilot_coverage < 100 || body.transparent_cabin))
		sight &= ~BLIND

/mob/living/exosuit/additional_sight_flags()
	return sight

/mob/living/exosuit/additional_see_invisible()
	return see_invisible

