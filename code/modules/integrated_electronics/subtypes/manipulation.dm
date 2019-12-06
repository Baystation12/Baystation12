/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in any energy weapon. \
	The first and second inputs need to be numbers which correspond to coordinates for the gun to fire at relative to the machine itself. \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible. Mode will switch between \
	lethal (TRUE) or stun (FALSE) modes. It uses the internal battery of the weapon itself, not the assembly. If you wish to fire the gun while the circuit is in \
	hand, you will need to use an assembly that is a gun."
	complexity = 20
	w_class = ITEM_SIZE_SMALL
	size = 3
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
		)
	outputs = list("reference to gun" = IC_PINTYPE_REF,
					"firemode" = IC_PINTYPE_STRING)
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN,
		"switch mode" = IC_PINTYPE_PULSE_IN

	)
	var/obj/item/weapon/gun/energy/installed_gun = null
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 30
	ext_cooldown = 1


/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	QDEL_NULL(installed_gun)
	return ..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/gun/energy))
		var/obj/item/weapon/gun/energy/gun = O
		if(installed_gun)
			to_chat(user, "<span class='warning'>There's already a weapon installed.</span>")
			return
		if(!user.unEquip(gun,src))
			return
		installed_gun = gun
		to_chat(user, "<span class='notice'>You slide \the [gun] into the firing mechanism.</span>")
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		if(installed_gun.fire_delay)
			cooldown_per_use = installed_gun.fire_delay * 10
		if(cooldown_per_use < 30)
			cooldown_per_use = 30 //If there's no defined fire delay let's put some
		if(installed_gun.charge_cost)
			power_draw_per_use = installed_gun.charge_cost
		set_pin_data(IC_OUTPUT, 1, weakref(installed_gun))
		if(installed_gun.firemodes.len)
			var/datum/firemode/fm = installed_gun.firemodes[installed_gun.sel_mode]
			set_pin_data(IC_OUTPUT, 2, fm.name)
		push_data()
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.dropInto(loc)
		to_chat(user, "<span class='notice'>You slide \the [installed_gun] out of the firing mechanism.</span>")
		size = initial(size)
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
		set_pin_data(IC_OUTPUT, 1, weakref(null))
		push_data()
	else
		to_chat(user, "<span class='notice'>There's no weapon to remove from the mechanism.</span>")

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work(ord)
	if(!installed_gun)
		return
	if(!isturf(assembly.loc) && !((IC_FLAG_CAN_FIRE & assembly.circuit_flags)  && ishuman(assembly.loc)))
		return
	set_pin_data(IC_OUTPUT, 1, weakref(installed_gun))
	push_data()
	switch(ord)
		if(1)
			var/datum/integrated_io/xo = inputs[1]
			var/datum/integrated_io/yo = inputs[2]
			if(assembly && !isnull(xo.data) && !isnull(yo.data))
				if(isnum(xo.data))
					xo.data = round(xo.data, 1)
				if(isnum(yo.data))
					yo.data = round(yo.data, 1)

				var/turf/T = get_turf(assembly)
				var/target_x = Clamp(T.x + xo.data, 0, world.maxx)
				var/target_y = Clamp(T.y + yo.data, 0, world.maxy)

				assembly.visible_message("<span class='danger'>[assembly] fires [installed_gun]!</span>")
				shootAt(locate(target_x, target_y, T.z))
		if(2)
			var/datum/firemode/next_firemode = installed_gun.switch_firemodes()
			set_pin_data(IC_OUTPUT, 2, next_firemode ? next_firemode.name : null)
			push_data()

/obj/item/integrated_circuit/manipulation/weapon_firing/proc/shootAt(turf/target)
	var/turf/T = get_turf(src)
	var/turf/U = target
	if(!istype(T) || !istype(U))
		return
	update_icon()
	var/obj/item/projectile/A = installed_gun.consume_next_projectile()
	if(!A)
		return
	//Shooting Code:
	A.shot_from = assembly.name
	A.firer = assembly
	A.launch(target, BP_CHEST)
	return A

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a 'dir' number as a direction to move towards.<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move one step in that direction, assuming it is not \
	being held, or anchored in some way. It should be noted that the ability to move is dependant on the type of assembly that this circuit inhabits; only drone assemblies can move."
	w_class = ITEM_SIZE_SMALL
	complexity = 10
	cooldown_per_use = 1
	ext_cooldown = 1
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list("obstacle" = IC_PINTYPE_REF)
	activators = list("step towards dir" = IC_PINTYPE_PULSE_IN,"on step"=IC_PINTYPE_PULSE_OUT,"blocked"=IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_MOVEMENT
	power_draw_per_use = 100

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(T && assembly)
		if(assembly.anchored || !assembly.can_move())
			return
		if(assembly.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				if(step(assembly, wanted_dir.data))
					activate_pin(2)
					return
				else
					set_pin_data(IC_OUTPUT, 1, assembly.collw)
					push_data()
					activate_pin(3)
					return FALSE
	return FALSE

/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades and prime them at will."
	extended_desc = "The time between priming and detonation is limited to between 1 to 12 seconds, but is optional. \
					If the input is not set, not a number, or a number less than 1, the grenade's built-in timing will be used. \
					Beware: Once primed, there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	cooldown_per_use = 10
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	var/obj/item/weapon/grenade/attached_grenade
	var/pre_attached_grenade_type

/obj/item/integrated_circuit/manipulation/grenade/Initialize()
	. = ..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.forceMove(loc)
	detach_grenade()
	return ..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(var/obj/item/weapon/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, "<span class='warning'>There is already a grenade attached!</span>")
		else if(user.unEquip(G,src))
			user.visible_message("<span class='warning'>\The [user] attaches \a [G] to \the [src]!</span>", "<span class='notice'>You attach \the [G] to \the [src].</span>")
			attach_grenade(G)
			G.forceMove(src)
	else
		return ..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message("<span class='warning'>\The [user] removes \an [attached_grenade] from \the [src]!</span>", "<span class='notice'>You remove \the [attached_grenade] from \the [src].</span>")
		user.put_in_hands(attached_grenade)
		detach_grenade()
	else
		return ..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		var/dt
		if(isnum(detonation_time.data) && detonation_time.data > 0)
			dt = Clamp(detonation_time.data, 1, 12)*10
		else
			dt = 15
		addtimer(CALLBACK(attached_grenade, /obj/item/weapon/grenade.proc/activate), dt)
		var/atom/holder = loc
		log_and_message_admins("activated a grenade assembly. Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(var/obj/item/weapon/grenade/G)
	attached_grenade = G
	G.forceMove(src)
	desc += " \An [attached_grenade] is attached to it!"

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	attached_grenade.dropInto(loc)
	attached_grenade = null
	desc = initial(desc)

/obj/item/integrated_circuit/manipulation/plant_module
	name = "plant manipulation module"
	desc = "Used to uproot weeds and harvest/plant trays."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a hydroponic tray or an item on an adjacent tile. \
	Mode input (0-harvest, 1-uproot weeds, 2-uproot plant, 3-plant seed) determines action. \
	Harvesting outputs a list of the harvested plants."
	w_class = ITEM_SIZE_TINY
	complexity = 10
	inputs = list("tray" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER,"item" = IC_PINTYPE_REF)
	outputs = list("result" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/plant_module/do_work()
	..()
	var/obj/acting_object = get_object()
	var/obj/OM = get_pin_data_as_type(IC_INPUT, 1, /obj)
	var/obj/O = get_pin_data_as_type(IC_INPUT, 3, /obj/item)

	if(!check_target(OM))
		push_data()
		activate_pin(2)
		return

	if(istype(OM,/obj/effect/vine) && check_target(OM) && get_pin_data(IC_INPUT, 2) == 2)
		qdel(OM)
		push_data()
		activate_pin(2)
		return

	var/obj/machinery/portable_atmospherics/hydroponics/TR = OM
	if(istype(TR))
		switch(get_pin_data(IC_INPUT, 2))
			if(0)
				var/list/harvest_output = TR.harvest()
				for(var/i in 1 to length(harvest_output))
					harvest_output[i] = weakref(harvest_output[i])

				if(length(harvest_output))
					set_pin_data(IC_OUTPUT, 1, harvest_output)
					push_data()
			if(1)
				TR.weedlevel = 0
				TR.update_icon()
			if(2)
				if(TR.seed) //Could be that they're just using it as a de-weeder
					TR.age = 0
					TR.health = 0
					if(TR.harvest)
						TR.harvest = FALSE //To make sure they can't just put in another seed and insta-harvest it
					qdel(TR.seed)
					TR.seed = null
				TR.weedlevel = 0 //Has a side effect of cleaning up those nasty weeds
				TR.dead = 0
				TR.update_icon()
			if(3)
				if(!check_target(O))
					activate_pin(2)
					return FALSE

				else if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/cutting))
					if(!TR.seed)
						acting_object.visible_message("<span class='notice'>[acting_object] plants [O].</span>")
						TR.dead = 0
						TR.seed = O
						TR.age = 1
						TR.health = TR.seed.get_trait(TRAIT_ENDURANCE)
						TR.lastcycle = world.time
						O.forceMove(TR)
						TR.update_icon()
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/seed_extractor
	name = "seed extractor module"
	desc = "Used to extract seeds from grown produce."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a plant item and extracts seeds from it, outputting the results to a list."
	complexity = 8
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list("result" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/seed_extractor/do_work()
	..()
	var/obj/item/weapon/reagent_containers/food/snacks/grown/O = get_pin_data_as_type(IC_INPUT, 1, /obj/item/weapon/reagent_containers/food/snacks/grown)
	if(!check_target(O))
		push_data()
		activate_pin(2)
		return
	var/list/seed_output = list()
	for(var/i in 1 to rand(1,4))
		var/obj/item/seeds/seeds = new(get_turf(O))
		seeds.seed = SSplants.seeds[O.plantname]
		seeds.seed_type = SSplants.seeds[O.seed.name]
		seeds.update_seed()
		seed_output += weakref(seeds)
	qdel(O)

	if(seed_output.len)
		set_pin_data(IC_OUTPUT, 1, seed_output)
		push_data()
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/grabber
	name = "grabber"
	desc = "A circuit with its own inventory for items. Used to grab and store things."
	icon_state = "grabber"
	extended_desc = "This circuit accepts a reference to an object to be grabbed, and can store up to 10 objects. Modes: 1 to grab, 0 to eject the first object, and -1 to eject all objects. If you throw something from a grabber's inventory with a thrower, the grabber will update its outputs accordingly."
	w_class = ITEM_SIZE_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER)
	outputs = list("first" = IC_PINTYPE_REF, "last" = IC_PINTYPE_REF, "amount" = IC_PINTYPE_NUMBER,"contents" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	var/max_items = 10

/obj/item/integrated_circuit/manipulation/grabber/do_work()
	var/atom/movable/acting_object = get_object()
	var/turf/T = get_turf(acting_object)
	var/obj/item/AM = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(!QDELETED(AM) && !istype(AM, /obj/item/device/electronic_assembly) && !istype(AM, /obj/item/device/transfer_valve) && !istype(AM, /obj/item/weapon/material/twohanded) && !istype(assembly.loc, /obj/item/weapon/implant))
		var/mode = get_pin_data(IC_INPUT, 2)
		if(mode == 1)
			if(check_target(AM))
				if((contents.len < max_items) && AM.w_class <= assembly.w_class)
					AM.forceMove(src)
		if(mode == 0)
			if(contents.len)
				var/obj/item/U = contents[1]
				U.forceMove(T)
		if(mode == -1)
			if(contents.len)
				var/obj/item/U
				for(U in contents)
					U.forceMove(T)
	update_outputs()
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/grabber/proc/update_outputs()
	if(contents.len)
		set_pin_data(IC_OUTPUT, 1, weakref(contents[1]))
		set_pin_data(IC_OUTPUT, 2, weakref(contents[contents.len]))
	else
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	set_pin_data(IC_OUTPUT, 4, contents)
	push_data()

/obj/item/integrated_circuit/manipulation/grabber/attack_self(var/mob/user)
	if(contents.len)
		var/turf/T = get_turf(src)
		var/obj/item/U
		for(U in contents)
			U.forceMove(T)
	update_outputs()
	push_data()

/obj/item/integrated_circuit/manipulation/claw
	name = "pulling claw"
	desc = "A claw and tether system."
	icon_state = "pull_claw"
	extended_desc = "This circuit accepts a reference to a thing to be pulled."
	w_class = ITEM_SIZE_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"dir" = IC_PINTYPE_DIR)
	outputs = list("is pulling" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT,"release" = IC_PINTYPE_PULSE_IN,"pull to dir" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	ext_cooldown = 1
	var/obj/item/pulling

/obj/item/integrated_circuit/manipulation/claw/Destroy()
	stop_pulling()
	return ..()

/obj/item/integrated_circuit/manipulation/claw/do_work(ord)
	var/obj/acting_object = get_object()
	var/obj/item/to_pull = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	switch(ord)
		if(1)
			if(can_pull(to_pull))
				if(check_target(to_pull, exclude_contents = TRUE))
					set_pin_data(IC_OUTPUT, 1, TRUE)
					pulling = to_pull
					acting_object.visible_message("\The [acting_object] starts pulling \the [to_pull] around.")
					GLOB.moved_event.register(to_pull, src, .proc/check_pull) //Whenever the target moves, make sure we can still pull it!
					GLOB.destroyed_event.register(to_pull, src, .proc/stop_pulling) //Stop pulling if it gets destroyed
					GLOB.moved_event.register(acting_object, src, .proc/pull) //Make sure we actually pull it.
			push_data()
		if(3)
			if(pulling)
				stop_pulling()
		if(4)
			if(pulling)
				var/dir = get_pin_data(IC_INPUT, 2)
				var/turf/G =get_step(get_turf(acting_object),dir)
				var/turf/Pl = get_turf(pulling)
				var/turf/F = get_step_towards(Pl,G)
				if(acting_object.Adjacent(F))
					if(!step_towards(pulling, F))
						F = get_step_towards2(Pl,G)
						if(acting_object.Adjacent(F))
							step_towards(pulling, F)
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/claw/proc/can_pull(var/obj/item/I)
	return assembly && I && I.w_class <= assembly.w_class && !I.anchored

/obj/item/integrated_circuit/manipulation/claw/proc/pull()
	var/obj/acting_object = get_object()
	if(istype(acting_object.loc, /turf))
		step_towards(pulling,src)
	else
		stop_pulling()

/obj/item/integrated_circuit/manipulation/claw/proc/check_pull()
	if(get_dist(pulling,src) > 1)
		stop_pulling()

/obj/item/integrated_circuit/manipulation/claw/proc/stop_pulling()
	var/atom/movable/AM = get_object()
	GLOB.moved_event.unregister(pulling, src)
	GLOB.moved_event.unregister(AM, src)
	AM.visible_message("\The [AM] stops pulling \the [pulling]")
	GLOB.destroyed_event.unregister(pulling, src)
	pulling = null
	set_pin_data(IC_OUTPUT, 1, FALSE)
	activate_pin(3)
	push_data()

/obj/item/integrated_circuit/manipulation/thrower
	name = "thrower"
	desc = "A compact launcher to throw things from inside or nearby tiles."
	extended_desc = "The first and second inputs need to be numbers which correspond to the coordinates to throw objects at relative to the machine itself. \
	The 'fire' activator will cause the mechanism to attempt to throw objects at the coordinates, if possible. Note that the \
	projectile needs to be inside the machine, or on an adjacent tile, and must be medium sized or smaller. The assembly \
	must also be a gun if you wish to throw something while the assembly is in hand."
	complexity = 25
	w_class = ITEM_SIZE_SMALL
	size = 2
	cooldown_per_use = 10
	ext_cooldown = 1
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER,
		"projectile" = IC_PINTYPE_REF
		)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/thrower/do_work()
	var/target_x_rel = round(get_pin_data(IC_INPUT, 1))
	var/target_y_rel = round(get_pin_data(IC_INPUT, 2))
	var/obj/item/A = get_pin_data_as_type(IC_INPUT, 3, /obj/item)

	if(!A || A.anchored || A.throwing || A == assembly || istype(A, /obj/item/weapon/material/twohanded) || istype(A, /obj/item/device/transfer_valve))
		return

	if (istype(assembly.loc, /obj/item/weapon/implant/compressed)) //Prevents the more abusive form of chestgun.
		return

	if(A.w_class > assembly.w_class)
		return

	if(!(IC_FLAG_CAN_FIRE & assembly.circuit_flags) && ishuman(assembly.loc))
		return

	// Is the target inside the assembly or close to it?
	if(!check_target(A, exclude_components = TRUE))
		return

	var/turf/T = get_turf(get_object())
	if(!T)
		return

	// If the item is in mob's inventory, try to remove it from there.
	if(ismob(A.loc))
		var/mob/living/M = A.loc
		if(!M.unEquip(A))
			return

	// If the item is in a grabber circuit we'll update the grabber's outputs after we've thrown it.
	var/obj/item/integrated_circuit/manipulation/grabber/G = A.loc

	var/x_abs = Clamp(T.x + target_x_rel, 0, world.maxx)
	var/y_abs = Clamp(T.y + target_y_rel, 0, world.maxy)
	var/range = round(Clamp(sqrt(target_x_rel*target_x_rel+target_y_rel*target_y_rel),0,8),1)

	assembly.visible_message("<span class='danger'>[assembly] has thrown [A]!</span>")
	log_attack("[assembly] \ref[assembly] has thrown [A].")
	A.dropInto(loc)
	A.throw_at(locate(x_abs, y_abs, T.z), range, 3)

	// If the item came from a grabber now we can update the outputs since we've thrown it.
	if(istype(G))
		G.update_outputs()

/obj/item/integrated_circuit/manipulation/bluespace_rift
	name = "bluespace rift generator"
	desc = "This powerful circuit can open rifts to another realspace location through bluespace."
	extended_desc = "If a valid teleporter console is supplied as input then its selected teleporter beacon will be used as destination point, \
					and if not an undefined destination point is selected. \
					Rift direction is a cardinal value determening in which direction the rift will be opened, relative the local north. \
					A direction value of 0 will open the rift on top of the assembly, and any other non-cardinal values will open the rift in the assembly's current facing."
	icon_state = "bluespace"
	complexity = 100
	size = 3
	cooldown_per_use = 10 SECONDS
	power_draw_per_use = 300
	inputs = list("teleporter", "rift direction")
	outputs = list()
	activators = list("open rift" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE

	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 200)

/obj/item/integrated_circuit/manipulation/bluespace_rift/do_work()
	var/obj/machinery/computer/teleporter/tporter = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/computer/teleporter)
	var/step_dir = get_pin_data(IC_INPUT, 2)
	if(!(get(z) in GetConnectedZlevels(get_z(tporter))))
		tporter = null

	var/turf/rift_location = get_turf(src)
	if(!rift_location || !isPlayerLevel(rift_location.z))
		playsound(src, 'sound/effects/sparks2.ogg', 50, 1)
		return

	if(isnum(step_dir) && (!step_dir || (step_dir in GLOB.cardinal)))
		rift_location = get_step(rift_location, step_dir) || rift_location
	else
		var/obj/item/device/electronic_assembly/assembly = get_object()
		if(assembly)
			rift_location = get_step(rift_location, assembly.dir) || rift_location

	if(tporter && tporter.locked && !tporter.one_time_use && tporter.operable())
		new /obj/effect/portal(rift_location, get_turf(tporter.locked))
	else
		var/turf/destination = get_random_turf_in_range(src, 10)
		if(destination)
			new /obj/effect/portal(rift_location, destination, 30 SECONDS, 33)
		else
			playsound(src, 'sound/effects/sparks2.ogg', 50, 1)


/obj/item/integrated_circuit/manipulation/ai
	name = "integrated intelligence control circuit"
	desc = "Similar in structure to a intellicard, this circuit allows the AI to pulse four different activators for control of a circuit."
	extended_desc = "Loading an AI is easy, all that is required is to insert the container into the device's slot. Unloading is a similar process, simply press\
					down on the device in question and the device/card should pop out (if applicable)."
	icon_state = "ai"
	complexity = 15
	var/mob/controlling
	cooldown_per_use = 1 SECOND
	power_draw_per_use = 20
	var/obj/item/aicard
	activators = list("Upwards" = IC_PINTYPE_PULSE_OUT, "Downwards" = IC_PINTYPE_PULSE_OUT, "Left" = IC_PINTYPE_PULSE_OUT, "Right" = IC_PINTYPE_PULSE_OUT)
	origin_tech = list(TECH_DATA = 4)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/ai/verb/open_menu()
	set name = "Control Inputs"
	set desc = "With this you can press buttons on the assembly you are attached to."
	set category = "Object"
	set src = usr.loc

	var/obj/item/device/electronic_assembly/assembly = get_object()
	assembly.closed_interact(usr)

/obj/item/integrated_circuit/manipulation/ai/relaymove(var/mob/user, var/direction)
	switch(direction)
		if(1)
			activate_pin(1)
		if(2)
			activate_pin(2)
		if(4)
			activate_pin(3)
		if(8)
			activate_pin(4)

/obj/item/integrated_circuit/manipulation/ai/proc/load_ai(var/mob/user, var/obj/item/card)
	if(controlling)
		to_chat(user, "<span class='warning'>There is already a card in there!</span>")
		return
	var/mob/living/L = locate(/mob/living) in card.contents
	if(L && L.key && user.unEquip(card))
		L.forceMove(src)
		controlling = L
		card.dropInto(src)
		aicard = card
		user.visible_message("\The [user] loads \the [card] into \the [src]'s device slot")
		to_chat(L, "<span class='notice'>### IICC FIRMWARE LOADED ###</span>")

/obj/item/integrated_circuit/manipulation/ai/proc/unload_ai()
	if(!controlling)
		return
	controlling.forceMove(aicard)
	to_chat(controlling, "<span class='notice'>### IICC FIRMWARE DELETED. HAVE A NICE DAY ###</span>")
	src.visible_message("\The [aicard] pops out of \the [src]!")
	aicard.dropInto(loc)
	aicard = null
	controlling = null


/obj/item/integrated_circuit/manipulation/ai/attackby(var/obj/item/I, var/mob/user)
	if(is_type_in_list(I, list(/obj/item/weapon/aicard, /obj/item/device/paicard, /obj/item/device/mmi)))
		load_ai(user, I)
	else return ..()

/obj/item/integrated_circuit/manipulation/ai/attack_self(user)
	unload_ai()

/obj/item/integrated_circuit/manipulation/ai/Destroy()
	unload_ai()
	return ..()

/obj/item/integrated_circuit/manipulation/anchoring
	name = "anchoring bolts"
	desc = "Pop-out anchoring bolts which can secure an assembly to the floor."

	outputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT
	)

	complexity = 8
	cooldown_per_use = 2 SECOND
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT
	origin_tech = list(TECH_ENGINEERING = 2)

/obj/item/integrated_circuit/manipulation/anchoring/do_work(ord)
	if(!isturf(assembly.loc))
		return

	// Doesn't work with anchorable assemblies
	if(assembly.circuit_flags & IC_FLAG_ANCHORABLE)
		visible_message("<span class='warning'>\The [get_object()]'s anchoring bolt circuitry blinks red. The preinstalled assembly anchoring bolts are in the way of the pop-out bolts!</span>")
		return

	if(ord == 1)
		assembly.anchored = !assembly.anchored

		visible_message(
			assembly.anchored ? \
			"<span class='notice'>\The [get_object()] deploys a set of anchoring bolts!</span>" \
			: \
			"<span class='notice'>\The [get_object()] retracts its anchoring bolts</span>"
		)

		set_pin_data(IC_OUTPUT, 1, assembly.anchored)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/manipulation/hatchlock
	name = "maintenance hatch lock"
	desc = "An electronically controlled lock for the assembly's maintenance hatch."
	extended_desc = "WARNING: If you lock the hatch with no circuitry to reopen it, there is no way to open the hatch again!"
	icon_state = "hatch_lock"

	outputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT
	)

	complexity = 4
	cooldown_per_use = 2 SECOND
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT
	origin_tech = list(TECH_ENGINEERING = 2)

	var/lock_enabled = FALSE

/obj/item/integrated_circuit/manipulation/hatchlock/do_work(ord)
	if(ord == 1)
		lock_enabled = !lock_enabled

		visible_message(
			lock_enabled ? \
			"<span class='notice'>\The [get_object()] whirrs. The screws are now covered.</span>" \
			: \
			"<span class='notice'>\The [get_object()] whirrs. The screws are now exposed!</span>"
		)

		set_pin_data(IC_OUTPUT, 1, lock_enabled)
		push_data()
		activate_pin(2)
