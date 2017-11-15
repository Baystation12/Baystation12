////FIELD GEN START //shameless copypasta from fieldgen, powersink, and grille
/obj/machinery/shieldwallgen
	name = "Shield Generator"
	desc = "A shield generator."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "Shield_Gen"
	anchored = 0
	density = 1
	req_one_access = list(access_engine_equip,access_research)
	var/active = 0
	var/power = 0
	var/locked = 1
	var/max_range = 8
	var/storedpower = 0
	flags = CONDUCT
	//There have to be at least two posts, so these are effectively doubled
	var/power_draw = 30 KILOWATTS //30 kW. How much power is drawn from powernet. Increase this to allow the generator to sustain longer shields, at the cost of more power draw.
	var/max_stored_power = 50 KILOWATTS //50 kW
	use_power = 0	//Draws directly from power net. Does not use APC power.
	active_power_usage = 1200

/obj/machinery/shieldwallgen/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()
	data["draw"] = round(power_draw)
	data["power"] = round(storedpower)
	data["maxpower"] = round(max_stored_power)
	data["current_draw"] = ((between(500, max_stored_power - storedpower, power_draw)) + power ? active_power_usage : 0)
	data["online"] = active == 2 ? 1 : 0

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shield.tmpl", "Shielding", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/shieldwallgen/update_icon()
//	if(stat & BROKEN) -TODO: Broken icon
	if(!active)
		icon_state = "Shield_Gen"
	else
		icon_state = "Shield_Gen +a"

/obj/machinery/shieldwallgen/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["toggle"])
		if(src.active >= 1)
			src.active = 0
			update_icon()

			usr.visible_message("\The [usr] turned the shield generator off.", \
				"You turn off the shield generator.", \
				"You hear heavy droning fade out.")
			for(var/dir in list(1,2,4,8)) src.cleanup(dir)
		else
			src.active = 1
			update_icon()
			usr.visible_message("\The [usr] turned the shield generator on.", \
				"You turn on the shield generator.", \
				"You hear heavy droning.")
	return 1

/obj/machinery/shieldwallgen/ex_act(var/severity)
	switch(severity)
		if(1)
			active = 0
			storedpower = 0
		if(2)
			storedpower -= rand(min(storedpower,max_stored_power/2), max_stored_power)
		if(3)
			storedpower -= rand(0, max_stored_power)

/obj/machinery/shieldwallgen/emp_act(var/severity)
	switch(severity)
		if(1)
			storedpower = 0
		if(2)
			storedpower -= rand(storedpower/2, storedpower)
		if(3)
			storedpower -= rand(storedpower/4, storedpower/2)
	..()

/obj/machinery/shieldwallgen/attack_hand(mob/user as mob)
	if(anchored != 1)
		to_chat(user, "<span class='warning'>The shield generator needs to be firmly secured to the floor first.</span>")
		return 1
	if(src.locked && !istype(user, /mob/living/silicon))
		to_chat(user, "<span class='warning'>The controls are locked!</span>")
		return 1
	if(power != 1)
		to_chat(user, "<span class='warning'>The shield generator needs to be powered by wire underneath.</span>")
		return 1

	src.ui_interact(user)
	src.add_fingerprint(user)

/obj/machinery/shieldwallgen/proc/power()
	if(!anchored)
		power = 0
		return 0
	var/turf/T = src.loc

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)	PN = C.powernet		// find the powernet of the connected cable

	if(PN)
		var/shieldload = between(500, max_stored_power - storedpower, power_draw)	//what we try to draw
		shieldload = PN.draw_power(shieldload) //what we actually get
		storedpower += shieldload

	//If we're still in the red, then there must not be enough available power to cover our load.
	if(storedpower <= 0)
		power = 0
		return 0

	power = 1	// IVE GOT THE POWER!
	return 1

/obj/machinery/shieldwallgen/Process()
	power = 0
	if(!(stat & BROKEN))
		power()
	if(power)
		storedpower -= active_power_usage //the generator post itself uses some power

	if(storedpower >= max_stored_power)
		storedpower = max_stored_power
	if(storedpower <= 0)
		storedpower = 0

	if(src.active == 1)
		if(!src.anchored == 1)
			src.active = 0
			return
		spawn(1)
			setup_field(1)
		spawn(2)
			setup_field(2)
		spawn(3)
			setup_field(4)
		spawn(4)
			setup_field(8)
		src.active = 2
	if(src.active >= 1)
		if(src.power == 0)
			src.visible_message("<span class='warning'>The [src.name] shuts down due to lack of power!</span>", \
				"You hear heavy droning fade out")
			src.active = 0
			update_icon()
			for(var/dir in list(1,2,4,8)) src.cleanup(dir)

/obj/machinery/shieldwallgen/proc/setup_field(var/NSEW = 0)
	var/turf/T = get_turf(src)
	if(!T) return
	var/turf/T2 = T
	var/obj/machinery/shieldwallgen/G
	var/steps = 0
	var/oNSEW = 0

	if(!NSEW)//Make sure its ran right
		return

	if(NSEW == 1)
		oNSEW = 2
	else if(NSEW == 2)
		oNSEW = 1
	else if(NSEW == 4)
		oNSEW = 8
	else if(NSEW == 8)
		oNSEW = 4

	for(var/dist = 0, dist <= (max_range+1), dist += 1) // checks out to 8 tiles away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			steps -= 1
			if(!G.active)
				return
			G.cleanup(oNSEW)
			break

	if(isnull(G))
		return

	T2 = src.loc

	for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
		var/field_dir = get_dir(T2,get_step(T2, NSEW))
		T = get_step(T2, NSEW)
		T2 = T
		var/obj/machinery/shieldwall/CF = new/obj/machinery/shieldwall/(src, G) //(ref to this gen, ref to connected gen)
		CF.loc = T
		CF.set_dir(field_dir)


/obj/machinery/shieldwallgen/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		if(active)
			to_chat(user, "Turn off the field generator first.")
			return

		else if(anchored == 0)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			to_chat(user, "You secure the external reinforcing bolts to the floor.")
			src.anchored = 1
			return

		else if(anchored == 1)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			to_chat(user, "You undo the external reinforcing bolts.")
			src.anchored = 0
			return

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if (src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	else
		src.add_fingerprint(user)
		..()


/obj/machinery/shieldwallgen/proc/cleanup(var/NSEW)
	var/obj/machinery/shieldwall/F
	var/obj/machinery/shieldwallgen/G
	var/turf/T = src.loc
	var/turf/T2 = src.loc

	for(var/dist = 0, dist <= (max_range+1), dist += 1) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/machinery/shieldwall) in T)
			F = (locate(/obj/machinery/shieldwall) in T)
			qdel(F)

		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			if(!G.active)
				break

/obj/machinery/shieldwallgen/Destroy()
	src.cleanup(NORTH)
	src.cleanup(SOUTH)
	src.cleanup(EAST)
	src.cleanup(WEST)
	. = ..()


//////////////Containment Field START
/obj/machinery/shieldwall
		name = "Shield"
		desc = "An energy shield."
		icon = 'icons/effects/effects.dmi'
		icon_state = "shieldwall"
		anchored = 1
		density = 1
		unacidable = 1
		light_range = 3
		var/needs_power = 0
		var/active = 1
		var/delay = 5
		var/last_active
		var/mob/U
		var/obj/machinery/shieldwallgen/gen_primary
		var/obj/machinery/shieldwallgen/gen_secondary
		var/power_usage = 800	//how much power it takes to sustain the shield
		var/generate_power_usage = 5000	//how much power it takes to start up the shield

/obj/machinery/shieldwall/New(var/obj/machinery/shieldwallgen/A, var/obj/machinery/shieldwallgen/B)
	..()
	update_nearby_tiles()
	src.gen_primary = A
	src.gen_secondary = B
	if(A && B && A.active && B.active)
		needs_power = 1
		if(prob(50))
			A.storedpower -= generate_power_usage
		else
			B.storedpower -= generate_power_usage
	else
		qdel(src) //need at least two generator posts

/obj/machinery/shieldwall/Destroy()
	update_nearby_tiles()
	..()

/obj/machinery/shieldwall/attack_hand(mob/user as mob)
	return

/obj/machinery/shieldwall/attackby(var/obj/item/I, var/mob/user)
	var/obj/machinery/shieldwallgen/G = prob(50) ? gen_primary : gen_secondary
	G.storedpower -= I.force*2500
	user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [I]!</span>")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/weapons/smash.ogg', 75, 1)

/obj/machinery/shieldwall/Process()
	if(needs_power)
		if(isnull(gen_primary)||isnull(gen_secondary))
			qdel(src)
			return

		if(!(gen_primary.active)||!(gen_secondary.active))
			qdel(src)
			return

		var/obj/machinery/shieldwallgen/G = prob(50) ? gen_primary : gen_secondary
		G.storedpower -= power_usage


/obj/machinery/shieldwall/bullet_act(var/obj/item/projectile/Proj)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G = prob(50) ? gen_primary : gen_secondary
		G.storedpower -= 400 * Proj.get_structure_damage()
	..()
	return


/obj/machinery/shieldwall/ex_act(severity)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G = prob(50) ? gen_primary : gen_secondary
		switch(severity)
			if(1.0) //big boom
				G.storedpower -= rand(30000, min(G.storedpower, 60000))

			if(2.0) //medium boom
				G.storedpower -= rand(15000, min(G.storedpower, 30000))

			if(3.0) //lil boom
				G.storedpower -= rand(5000, min(G.storedpower, 15000))
	return


/obj/machinery/shieldwall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSGLASS))
		return prob(20)
	else
		if (istype(mover, /obj/item/projectile))
			return prob(10)
		else
			return !src.density

/obj/machinery/shieldwallgen/online
	anchored = 1
	active = 1

/obj/machinery/shieldwallgen/online/Initialize()
	storedpower = max_stored_power
	. = ..()