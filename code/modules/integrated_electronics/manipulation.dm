
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
	being held, or anchored in some way."
	complexity = 20
	inputs = list("dir num")
	outputs = list()
	activators = list("step towards dir")

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(istype(loc, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/machine = loc
		if(machine.anchored || machine.w_class >= 4)
			return
		if(machine.loc && machine.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				step(machine, wanted_dir.data)
