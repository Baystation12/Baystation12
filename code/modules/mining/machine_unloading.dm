/**********************Unloading unit**************************/


/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/unloads_per_tick = 20


/obj/machinery/mineral/unloading_machine/New()
	..()
	spawn( 5 )
		for (var/dir in GLOB.cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in GLOB.cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return

/obj/machinery/mineral/unloading_machine/process()
	if (src.output && src.input)
		if (locate(/obj/structure/ore_box, input.loc))
			var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input.loc)
			var/i = 0
			for (var/obj/item/weapon/ore/O in BOX.contents)
				BOX.contents -= O
				O.loc = output.loc
				i++
				if (i>=unloads_per_tick)
					return
				CHECK_TICK
		if (locate(/obj/item, input.loc))
			var/obj/item/O
			var/i
			for (i = 0; i<unloads_per_tick; i++)
				O = locate(/obj/item, input.loc)
				if (O)
					O.loc = src.output.loc
				else
					return
				CHECK_TICK
	return