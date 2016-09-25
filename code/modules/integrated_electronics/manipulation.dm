
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
	inputs = list("target ref", "injection amount")
	outputs = list()
	activators = list("inject")
	var/inject_amount = 5

/obj/item/integrated_circuit/manipulation/injector/New()
	..()
	create_reagents(30)
	var/datum/integrated_io/amount = inputs[2]
	amount.data = inject_amount

/obj/item/integrated_circuit/manipulation/injector/on_data_written()
	var/datum/integrated_io/amount = inputs[2]
	if(isnum(amount.data))
		amount.data = Clamp(amount.data, 0, 30)
		inject_amount = amount.data

/obj/item/integrated_circuit/manipulation/injector/do_work()
	var/datum/integrated_io/target = inputs[1]
	var/atom/movable/AM = target.data_as_type(/atom/movable)
	if(!istype(AM)) //Invalid input
		return
	if(!reagents.total_volume) // Empty
		return
	if(AM.Adjacent(get_turf(src)))
		if(!AM.reagents)
			return
		if(!AM.is_open_container() && !ismob(AM) )
			return
		if(!AM.reagents.get_free_space())
			return

		if(isliving(AM))
			var/mob/living/L = AM
			if(!L.can_inject(null, 0, BP_TORSO))
				return
			loc.visible_message("<span class='warning'>[src] is trying to inject [AM]!</span>")
			sleep(3 SECONDS)
			if(!AM.Adjacent(get_turf(src)))
				return
			var/contained = reagents.get_reagents()
			var/trans = reagents.trans_to_mob(target, inject_amount, CHEM_BLOOD)
			message_admins("[src] injected \the [AM] with [trans]u of [english_list(contained)].")
			to_chat(AM, "<span class='notice'>You feel a tiny prick!</span>")
			visible_message("<span class='warning'>[src] injects [AM]!</span>")
		else
			reagents.trans_to(AM, inject_amount)

/obj/item/integrated_circuit/manipulation/reagent_pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a machine, or even nearby it."
	icon_state = "reagent_pump"
	extended_desc = "This is a pump, which will move liquids from the source ref to the target ref.  The third pin determines \
	how much liquid is moved per pulse, between 0 and 50.  The pump can move reagents to any open container inside the machine, or \
	outside the machine if it is next to the machine.  Note that this cannot be used on entities."
	flags = OPENCONTAINER
	complexity = 8
	inputs = list("source ref", "target ref", "injection amount")
	outputs = list()
	activators = list("transfer reagents")
	var/transfer_amount = 10

/obj/item/integrated_circuit/manipulation/reagent_pump/New()
	..()
	var/datum/integrated_io/amount = inputs[3]
	amount.data = transfer_amount

/obj/item/integrated_circuit/manipulation/reagent_pump/on_data_written()
	var/datum/integrated_io/amount = inputs[3]
	if(isnum(amount.data))
		amount.data = Clamp(amount.data, 0, 50)
		transfer_amount = amount.data

/obj/item/integrated_circuit/manipulation/reagent_pump/do_work()
	var/datum/integrated_io/A = inputs[1]
	var/datum/integrated_io/B = inputs[2]
	var/atom/movable/source = A.data_as_type(/atom/movable)
	var/atom/movable/target = B.data_as_type(/atom/movable)
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
	var/datum/integrated_io/A = outputs[1]
	A.data = reagents.total_volume
	A.push_data()

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
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
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

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(istype(loc, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/machine = loc
		if(machine.anchored || machine.w_class >= ITEMSIZE_LARGE)
			return
		if(machine.loc && machine.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				step(machine, wanted_dir.data)
