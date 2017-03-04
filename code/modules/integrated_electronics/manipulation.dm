/obj/item/integrated_circuit/manipulation/smoke
	name = "smoke generator"
	desc = "Unlike most electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	extended_desc = "This smoke generator creates clouds of smoke on command.  It can also hold liquids inside, which will go \
	into the smoke clouds when activated."
	flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 30 SECONDS
	inputs = list()
	outputs = list()
	activators = list("create smoke")

/obj/item/integrated_circuit/manipulation/smoke/New()
	..()
	create_reagents(100)

/obj/item/integrated_circuit/manipulation/smoke/do_work()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	var/datum/effect/effect/system/smoke_spread/chem/smoke_system = new()
	smoke_system.set_up(reagents, 10, 0, get_turf(src))
	spawn(0)
		for(var/i = 1 to 8)
			smoke_system.start()
		reagents.clear_reagents()

/obj/item/integrated_circuit/manipulation/injector
	name = "integrated hypo-injector"
	desc = "This scary looking thing is able to pump liquids into whatever it's pointed at."
	icon_state = "injector"
	extended_desc = "This autoinjector can push reagents into another container or someone else outside of the machine.  The target \
	must be adjacent to the machine, and if it is a person, they cannot be wearing thick clothing."
	flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list("target ref", "injection amount" = 5)
	outputs = list()
	activators = list("inject")

/obj/item/integrated_circuit/manipulation/injector/New()
	..()
	create_reagents(30)

/obj/item/integrated_circuit/manipulation/injector/proc/inject_amount()
	var/amount = get_pin_data(IC_INPUT, 2)
	if(isnum(amount))
		return Clamp(amount, 0, 30)

/obj/item/integrated_circuit/manipulation/injector/do_work()
	set waitfor = 0 // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing

	var/assembly = get_assembly(loc)
	if(!assembly)
		return // Bad circuit, bad.

	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	if(!istype(AM)) //Invalid input
		return
	if(!reagents.total_volume) // Empty
		return
	if(AM.can_be_injected_by(assembly))
		if(isliving(AM))
			var/turf/T = get_turf(AM)
			T.visible_message("<span class='warning'>\The [assembly] is trying to inject \the [AM]!</span>")
			sleep(3 SECONDS)
			if(!AM.can_be_injected_by(assembly))
				return
			var/contained = reagents.get_reagents()
			var/trans = reagents.trans_to_mob(AM, inject_amount(), CHEM_BLOOD)
			message_admins("\The [assembly] injected \the [AM] with [trans]u of [english_list(contained)].")
			to_chat(AM, "<span class='notice'>You feel a tiny prick!</span>")
			visible_message("<span class='warning'>\The [assembly] injects \the [AM]!</span>")
		else
			reagents.trans_to(AM, inject_amount())

/obj/item/integrated_circuit/manipulation/reagent_pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a machine, or even nearby it."
	icon_state = "reagent_pump"
	extended_desc = "This is a pump, which will move liquids from the source ref to the target ref.  The third pin determines \
	how much liquid is moved per pulse, between 0 and 50.  The pump can move reagents to any open container inside the machine, or \
	outside the machine if it is next to the machine.  Note that this cannot be used on entities."
	flags = OPENCONTAINER
	complexity = 8
	inputs = list("source ref", "target ref", "injection amount" = 10)
	outputs = list()
	activators = list("transfer reagents")
	var/transfer_amount = 10

/obj/item/integrated_circuit/manipulation/reagent_pump/on_data_written()
	var/amount = get_pin_data(IC_INPUT, 3)
	if(isnum(amount))
		transfer_amount = Clamp(amount, 0, 50)

/obj/item/integrated_circuit/manipulation/reagent_pump/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)
	if(!istype(source) || !istype(target)) //Invalid input
		return
	var/turf/T = get_turf(src)
	if(source.Adjacent(T) && target.Adjacent(T))
		if(!source.reagents || !target.reagents)
			return
		if(ismob(source) || ismob(target))
			return
		if(!source.is_open_container() || !target.is_open_container())
			return
		if(!source.reagents.get_free_space() || !target.reagents.get_free_space())
			return

		source.reagents.trans_to(target, transfer_amount)

// May make a reagent subclass of circuits in future.
/obj/item/integrated_circuit/manipulation/reagent_storage
	name = "reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u."
	icon_state = "reagent_storage"
	extended_desc = "This is effectively an internal beaker."
	flags = OPENCONTAINER
	complexity = 4
	inputs = list()
	outputs = list("volume used")
	activators = list()

/obj/item/integrated_circuit/manipulation/reagent_storage/New()
	..()
	create_reagents(60)

/obj/item/integrated_circuit/manipulation/reagent_storage/on_reagent_change()
	set_pin_data(IC_OUTPUT, 1, reagents && reagents.total_volume)

/obj/item/integrated_circuit/manipulation/reagent_storage/cryo
	name = "cryo reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u.  This will also suppress reactions."
	icon_state = "reagent_storage_cryo"
	extended_desc = "This is effectively an internal cryo beaker."
	flags = OPENCONTAINER | NOREACT
	complexity = 8
	inputs = list()
	outputs = list("volume used")
	activators = list()

/obj/item/integrated_circuit/manipulation/locomotion
	activators = list("step")

/obj/item/integrated_circuit/manipulation/locomotion/do_work(var/activation_pin)
	var/turf/T = get_turf(src)
	if(!T || !istype(loc, /obj/item/device/electronic_assembly) || activation_pin != activators[1])
		return
	var/obj/item/device/electronic_assembly/assembly = loc
	if(assembly.anchored || assembly.w_class >= ITEM_SIZE_LARGE)
		return
	if(assembly.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
		circuit_move(assembly)
		return

/obj/item/integrated_circuit/manipulation/locomotion/proc/circuit_move(var/obj/item/moving_object)
	step(moving_object, moving_object.dir)

/obj/item/integrated_circuit/manipulation/locomotion/simple
	name = "simple locomotion circuit"
	desc = "This allows a machine to move in a straight direction, or turn left or right."
	icon_state = "locomotion_simple"
	extended_desc = "this circuit turns when pulsing the turn left or turn right activators and\
	only moves forward when the step forward activator is pulsed."
	activators = list("step forward", "turn left", "turn right")

/obj/item/integrated_circuit/manipulation/locomotion/simple/do_work(var/activation_pin)
	var/obj/item/assembly = get_assembly(loc)
	if(activation_pin != activators[1])
		assembly.dir = turn(assembly.dir, 90 * (activation_pin == activators[2] ? 1 : -1))
	else
		..()

/obj/item/integrated_circuit/manipulation/locomotion/electronic
	name = "electronic locomotion circuit"
	desc = "This allows a machine to move in a given direction via electronic data input."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a number as a direction to move towards.<br>  \
	North/Fore = 1,<br>\
	South/Aft = 2,<br>\
	East/Starboard = 4,<br>\
	West/Port = 8,<br>\
	Northeast = 5,<br>\
	Northwest = 9,<br>\
	Southeast = 6,<br>\
	Southwest = 10<br>\
	<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move a meter in that direction, assuming it is not \
	being held, or anchored in some way.  It should be noted that heavy machines will be unable to move."
	complexity = 20
	inputs = list("dir num")
	outputs = list()
	activators = list("step towards dir")

/obj/item/integrated_circuit/manipulation/locomotion/electronic/circuit_move(var/obj/item/moving_object)
	var/datum/integrated_io/wanted_dir = inputs[1]
	if(isnum(wanted_dir.data))
		step(moving_object, wanted_dir.data)

/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades at prime them at will."
	extended_desc = "Time between priming and detonation is limited to between 1 to 12 seconds but is optional. \
					If unset, not a number, or a number less than 1 then the grenade's built-in timing will be used. \
					Beware: Once primed there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	size = 2
	inputs = list("detonation time")
	outputs = list()
	activators = list("prime grenade")
	var/obj/item/weapon/grenade/attached_grenade
	var/pre_attached_grenade_type

/obj/item/integrated_circuit/manipulation/grenade/New()
	..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.dropInto(loc)
	detach_grenade()
	. =..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(var/obj/item/weapon/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, "<span class='warning'>There is already a grenade attached!</span>")
		else if(user.unEquip(G, target = src))
			user.visible_message("<span class='warning'>\The [user] attaches \a [G] to \the [src]!</span>", "<span class='notice'>You attach \the [G] to \the [src].</span>")
			attach_grenade(G)
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message("<span class='warning'>\The [user] removes \an [attached_grenade] from \the [src]!</span>", "<span class='notice'>You remove \the [attached_grenade] from \the [src].</span>")
		user.put_in_any_hand_if_possible(attached_grenade) || attached_grenade.dropInto(loc)
		detach_grenade()
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		if(isnum(detonation_time.data) && detonation_time.data > 0)
			attached_grenade.det_time = between(1, detonation_time.data, 12) SECONDS
		attached_grenade.activate()
		var/atom/holder = loc
		log_and_message_admins("activated a grenade assembly. Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(var/obj/item/weapon/grenade/G)
	attached_grenade = G
	destroyed_event.register(attached_grenade, src, /obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade)
	size += G.w_class
	desc += " \An [attached_grenade] is attached to it!"

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	destroyed_event.unregister(attached_grenade, src, /obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade)
	attached_grenade = null
	size = initial(size)
	desc = initial(desc)

/obj/item/integrated_circuit/manipulation/grenade/frag
	pre_attached_grenade_type = /obj/item/weapon/grenade/frag

/obj/item/integrated_circuit/manipulation/bluespace_rift
	name = "bluespace rift generator"
	desc = "This powerful circuit can open rifts to another realspace location through bluespace."
	extended_desc = "If a valid teleporter console is supplied as input then its selected teleporter beacon will be used as destination point, \
					and if not an undefined destination point is selected. \
					Rift direction is a cardinal value determening in which direction the rift will be opened, relative the local north. \
					A direction value of 0 will open the rift on top of the assembly, and any other non-cardinal values will open the rift in the assembly's current facing."
	icon_state = "bluespace"
	complexity = 25
	size = 3
	cooldown_per_use = 10 SECONDS
	inputs = list("teleporter", "rift direction" = 0)
	outputs = list()
	activators = list("open rift")

	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 10000)

/obj/item/integrated_circuit/manipulation/bluespace_rift/do_work()
	var/obj/machinery/computer/teleporter/tporter = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/computer/teleporter)
	var/step_dir = get_pin_data(IC_INPUT, 2)

	var/turf/rift_location = get_turf(src)
	if(!rift_location || !isPlayerLevel(rift_location.z))
		playsound(src, 'sound/effects/sparks2.ogg', 50, 1)
		return

	if(isnum(step_dir) && (!step_dir || (step_dir in cardinal)))
		rift_location = get_step(rift_location, step_dir) || rift_location
	else
		rift_location = get_step(rift_location, dir) || rift_location

	if(tporter && tporter.locked && !tporter.one_time_use && tporter.operable())
		new /obj/effect/portal(rift_location, get_turf(tporter.locked))
	else
		var/turf/destination = get_random_turf_in_range(src, 10)
		if(destination)
			new /obj/effect/portal(rift_location, destination)
		else
			playsound(src, 'sound/effects/sparks2.ogg', 50, 1)

/obj/item/integrated_circuit/manipulation/ai
	name = "integrated intelligence control circuit"
	desc = "Similar in structure to a intellicard, this circuit allows the AI to pulse four different activators for control of a circuit."
	extended_desc = "Loading an AI is easy, all that is required is to insert the container into the device's slot. Unloading is a similar process, simply press\
					down on the device in question and the device/card should pop out (if applicable)."
	icon_state = "ai"
	size = 2
	complexity = 15
	var/mob/controlling
	cooldown_per_use = 2 SECONDS
	var/obj/item/aicard
	activators = list("Upwards", "Downwards", "Left", "Right")
	origin_tech = list(TECH_DATA = 4)

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
	if(L && L.key)
		L.forceMove(src)
		controlling = L
		card.forceMove(src)
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
	if(is_type_in_list(I, list(/obj/item/weapon/aicard, /obj/item/device/paicard, /obj/item/device/mmi/digital)))
		load_ai(user, I)
	else return ..()

/obj/item/integrated_circuit/manipulation/ai/attack_self(user)
	unload_ai()

/obj/item/integrated_circuit/manipulation/ai/Destroy()
	unload_ai()
	return ..()