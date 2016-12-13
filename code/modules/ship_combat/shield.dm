////FIELD GEN START //shameless copypasta from fieldgen, powersink, and grille
/obj/machinery/space_battle/shieldwallgen
		name = "Shield Generator"
		desc = "A shield generator."
		icon_state = "Shield_Gen"
		anchored = 0
		density = 1
		req_access = list(access_engine_equip)
		var/active = 0
		var/power = 0
		var/state = 0
		var/steps = 0
		var/last_check = 0
		var/check_delay = 10
		var/recalc = 0
		var/locked = 1
		var/destroyed = 0
		var/directwired = 1
//		var/maxshieldload = 200
		var/obj/structure/cable/attached		// the attached cable
		var/storedpower = 0
		flags = CONDUCT
		//There have to be at least two posts, so these are effectively doubled
		var/power_draw = 45000 //30 kW. How much power is drawn from powernet. Increase this to allow the generator to sustain longer shields, at the cost of more power draw.
		var/max_stored_power = 50000 //50 kW
		use_power = 0	//Draws directly from power net. Does not use APC power.

		component_type = /obj/item/weapon/component/shield
		has_circuit = 1
		resistance = 3

		var/strength = 1

/obj/machinery/space_battle/shieldwallgen/New()
	..()
	var/obj/item/weapon/component/shield/comp = component
	storedpower = comp.stored_power
	max_stored_power = comp.stored_power

/obj/machinery/space_battle/shieldwallgen/break_machine(var/dmg = 0)
	if(dmg)
		var/obj/item/weapon/component/shield/comp = component
		comp.stored_power -= 1000 * dmg

/obj/machinery/space_battle/shieldwallgen/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()
	var/efficiency = get_efficiency(-1,1)
	data["draw"] = round(power_draw)
	data["power"] = round(storedpower)
	data["maxpower"] = round(max_stored_power)
	data["current_draw"] = ((between(500, max_stored_power - storedpower, power_draw)*efficiency) + 1200*efficiency)
	data["online"] = active == 2 ? 1 : 0
	data["efficiency"] = get_efficiency(1,0)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shield.tmpl", "Shielding", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/space_battle/shieldwallgen/update_icon()
	if(stat & BROKEN) return ..()
	else
		if(!active)
			icon_state = "Shield_Gen"
		else
			icon_state = "Shield_Gen_active"

/obj/machinery/space_battle/shieldwallgen/Topic(href, href_list)
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


/obj/machinery/space_battle/shieldwallgen/ex_act(var/severity)
	switch(severity)
		if(1)
			active = 0
			storedpower = 0
		if(2)
			storedpower -= rand(min(storedpower,max_stored_power/2), max_stored_power)
		if(3)
			storedpower -= rand(0, max_stored_power)
	for(var/obj/O in contents)
		O.ex_act(severity)
	return 1

/obj/machinery/space_battle/shieldwallgen/emp_act(var/severity)
	if(1)
		storedpower -= rand(storedpower/2, storedpower)
	if(2)
		storedpower -= rand(storedpower/2, storedpower)
	..()
/obj/machinery/space_battle/shieldwallgen/attack_hand(mob/user as mob)
	if(state != 1)
		user << "\red The shield generator needs to be firmly secured to the floor first."
		return 1
	if(src.locked && !istype(user, /mob/living/silicon))
		user << "\red The controls are locked!"
		return 1
	if(power != 1)
		user << "\red The shield generator needs to be powered by wire underneath."
		return 1

	src.ui_interact(user)
	src.add_fingerprint(user)

/obj/machinery/space_battle/shieldwallgen/proc/power()
	if(!anchored)
		power = 0
		return 0
	var/turf/T = src.loc

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)	PN = C.powernet		// find the powernet of the connected cable
	var/efficiency = get_efficiency(-1,1)

	if(PN)
		var/shieldload = (between(500, max_stored_power - storedpower, power_draw)*efficiency)	//what we try to draw
		shieldload = PN.draw_power(shieldload) //what we actually get
		storedpower += (shieldload*max(0.5, get_efficiency(1,1)))

	//If we're still in the red, then there must not be enough available power to cover our load.
	if(storedpower <= 0)
		power = 0
		return 0

	power = 1	// IVE GOT THE POWER!
	return 1

/obj/machinery/space_battle/shieldwallgen/process()
	power = 0
	if(!(stat & BROKEN))
		power()
	var/efficiency = get_efficiency(-1,1)
	if(power)
		storedpower -= 1200*efficiency //the generator post itself uses some power

	if(storedpower >= max_stored_power)
		storedpower = max_stored_power
	if(storedpower <= 0)
		storedpower = 0
//	if(shieldload >= maxshieldload) //there was a loop caused by specifics of process(), so this was needed.
//		shieldload = maxshieldload

	if(src.active == 1)
		if(!src.state == 1)
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
			src.visible_message("\red The [src.name] shuts down due to lack of power!", \
				"You hear heavy droning fade out")
			src.active = 0
			update_icon()
			for(var/dir in list(1,2,4,8)) src.cleanup(dir)

/obj/machinery/space_battle/shieldwallgen/proc/setup_field(var/NSEW = 0)
	var/turf/T = src.loc
	var/turf/T2 = src.loc
	var/obj/machinery/space_battle/shieldwallgen/G
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

	for(var/dist = 0, dist <= 15, dist += 1) // checks out to 8 tiles away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		if(locate(/obj/machinery/space_battle/shieldwallgen) in T)
			G = (locate(/obj/machinery/space_battle/shieldwallgen) in T)
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


/obj/machinery/space_battle/shieldwallgen/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		if(active)
			user << "Turn off the field generator first."
			return

		else if(state == 0)
			state = 1
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			user << "You secure the external reinforcing bolts to the floor."
			src.anchored = 1
			return

		else if(state == 1)
			state = 0
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			user << "You undo the external reinforcing bolts."
			src.anchored = 0
			return

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda))
		if (src.allowed(user))
			src.locked = !src.locked
			user << "Controls are now [src.locked ? "locked." : "unlocked."]"
		else
			user << "\red Access denied."
		return

	else
		src.add_fingerprint(user)
		..()


/obj/machinery/space_battle/shieldwallgen/proc/cleanup(var/NSEW)
	var/obj/machinery/shieldwall/F
	var/obj/machinery/space_battle/shieldwallgen/G
	var/turf/T = src.loc
	var/turf/T2 = src.loc

	for(var/dist = 0, dist <= 9, dist += 1) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/machinery/shieldwall) in T)
			F = (locate(/obj/machinery/shieldwall) in T)
			qdel(F)

		if(locate(/obj/machinery/space_battle/shieldwallgen) in T)
			G = (locate(/obj/machinery/space_battle/shieldwallgen) in T)
			if(!G.active)
				break

/obj/machinery/space_battle/shieldwallgen/Destroy()
	src.cleanup(1)
	src.cleanup(2)
	src.cleanup(4)
	src.cleanup(8)
	..()


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
//		var/power = 10
		var/delay = 5
		var/last_active
		var/mob/U
		var/obj/machinery/space_battle/shieldwallgen/gen_primary
		var/obj/machinery/space_battle/shieldwallgen/gen_secondary
		var/power_usage = 800	//how much power it takes to sustain the shield
		var/generate_power_usage = 5000	//how much power it takes to start up the shield

/obj/machinery/shieldwall/New(var/obj/machinery/space_battle/shieldwallgen/A, var/obj/machinery/space_battle/shieldwallgen/B)
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
	if(prob(50))
		gen_primary.storedpower -= 2500*I.force
	else
		gen_secondary.storedpower -= 2500*I.force
	user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [I]!</span>")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/weapons/smash.ogg', 75, 1)

/obj/machinery/shieldwall/process()
	if(needs_power)
		if(isnull(gen_primary)||isnull(gen_secondary))
			qdel(src)
			return

		if(!(gen_primary.active)||!(gen_secondary.active))
			qdel(src)
			return

		if(prob(50))
			gen_primary.storedpower -= power_usage
		else
			gen_secondary.storedpower -= power_usage


/obj/machinery/shieldwall/bullet_act(var/obj/item/projectile/Proj)
	if(needs_power)
		var/obj/machinery/space_battle/shieldwallgen/G
		if(prob(50))
			G = gen_primary
		else
			G = gen_secondary
		G.storedpower -= 400 * Proj.get_structure_damage()
	..()
	return


/obj/machinery/shieldwall/ex_act(severity)
	if(needs_power)
		var/obj/machinery/space_battle/shieldwallgen/G
		switch(severity)
			if(1.0) //big boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= rand(90000, 120000)

			if(2.0) //medium boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= rand(30000, 90000)

			if(3.0) //lil boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= rand(12000, 30000)
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


/obj/machinery/space_battle/shieldwallgen/remote
	state = 1
	max_stored_power = 1000000
	storedpower = 100000
	req_access = list()
	req_one_access = list(1,2,3,4)
	anchored = 1
	var/start_active = 1

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			switch(A.team)
				if(1)
					req_one_access = list(5)
				if(2)
					req_one_access = list(15)
				if(3)
					req_one_access = list(25)
				if(4)
					req_one_access = list(35)

		if(start_active)
			spawn(30)
				active = 1
				update_icon()

/obj/machinery/space_battle/shieldwallgen/remote/weak
	component_type = /obj/item/weapon/component/shield/compact
/obj/machinery/space_battle/shieldwallgen/remote/strong
	component_type = /obj/item/weapon/component/shield/nuclear
/obj/machinery/space_battle/shieldwallgen/remote/ultrastrong
	component_type = /obj/item/weapon/component/shield/fission


/obj/machinery/button/remote/shield
	var/id_tag = 0
	var/on = 0

/obj/machinery/button/remote/shield/trigger()
	on = !on
	for(var/obj/machinery/space_battle/shieldwallgen/remote/R in world)
		if(R.id_tag == src.id_tag || R.id_tag == src.id)
			R.active = on
			if(on)
				R.update_icon()
			else
				R.update_icon()





