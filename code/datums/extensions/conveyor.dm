/datum/extension/conveyor
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE
	var/move_capacity = 10

/datum/extension/conveyor/New()
	..()
	SSconveyor.all_conveyors[src] = TRUE

/datum/extension/conveyor/Destroy()
	SSconveyor -= src
	. = ..()

/datum/extension/conveyor/proc/inactive()
	return TRUE

/datum/extension/conveyor/proc/process()

/datum/extension/conveyor/proc/get_target()

/datum/extension/conveyor/proc/get_conveyor_on_turf(var/turf/turf)
	. = get_extension(turf, /datum/extension/conveyor)
	if(.)
		return
	for(var/atom/movable/thing in turf)
		. = get_extension(thing, /datum/extension/conveyor)
		if(.)
			return		

/datum/extension/conveyor/proc/standard_move_all(var/atom/start, var/atom/end)
	if(!istype(start) || !istype(end))
		return
	var/can_move_items = move_capacity - length(end.contents)
	for(var/atom/movable/A in start)
		if(can_move_items <= 0)
			break
		if(!A.anchored)
			step(A, get_dir(start, end))
			can_move_items--

/datum/extension/conveyor/belt
	expected_type = /obj/machinery/conveyor

/datum/extension/conveyor/belt/inactive()
	var/obj/machinery/conveyor/conveyor = holder
	return !conveyor.operating

/datum/extension/conveyor/belt/get_target()
	var/obj/machinery/conveyor/conveyor = holder
	var/target = get_step(conveyor, conveyor.movedir)
	return get_conveyor_on_turf(target) || target

/datum/extension/conveyor/belt/process()
	var/obj/machinery/conveyor/conveyor = holder
	var/target_dir = conveyor.movedir
	standard_move_all(get_turf(holder), get_step(holder, target_dir))
	. = list()
	for(var/dir in (GLOB.cardinal - target_dir))
		var/datum/extension/conveyor/conveyor_extension = get_conveyor_on_turf(get_step(conveyor, dir))
		if(conveyor_extension && conveyor_extension.get_target() == src)
			.[conveyor_extension] = TRUE	

/datum/extension/conveyor/ore_unloader
	expected_type = /obj/machinery/mineral
	move_capacity = 25

/datum/extension/conveyor/ore_unloader/get_target()
	var/obj/machinery/mineral/conveyor = holder
	return get_conveyor_on_turf(conveyor.output_turf) || conveyor.output_turf

/datum/extension/conveyor/ore_unloader/inactive()
	var/obj/machinery/mineral/conveyor = holder
	return conveyor.inoperable()

/datum/extension/conveyor/ore_unloader/process()
	var/obj/machinery/mineral/conveyor = holder
	if(conveyor.input_turf && conveyor.output_turf)
		var/ore_this_tick = move_capacity - length(conveyor.output_turf.contents)
		for(var/obj/structure/ore_box/unloading in conveyor.input_turf)
			for(var/obj/item/weapon/ore/_ore in unloading)
				_ore.dropInto(conveyor.output_turf)
				if(--ore_this_tick <= 0)
					return
		for(var/obj/item/_ore in conveyor.input_turf)
			if(_ore.simulated && !_ore.anchored)
				_ore.dropInto(conveyor.output_turf)
				if(--ore_this_tick <= 0)
					return