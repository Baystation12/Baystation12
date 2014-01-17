/////////////////////////
// the elusive up pipe //
/////////////////////////
obj/machinery/atmospherics/pipe/up
		icon = 'code/TriDimension/multiz_pipe.dmi'
		icon_state = "up"

		name = "upwards pipe"
		desc = "A pipe segment to connect upwards."

		volume = 70

		dir = SOUTH
		initialize_directions = SOUTH

		var/obj/machinery/atmospherics/node1	//connection on the same Z
		var/obj/machinery/atmospherics/node2	//connection on the other Z

		var/minimum_temperature_difference = 300
		var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

		var/maximum_pressure = 70*ONE_ATMOSPHERE
		var/fatigue_pressure = 55*ONE_ATMOSPHERE
		alert_pressure = 55*ONE_ATMOSPHERE


		level = 1

obj/machinery/atmospherics/pipe/up/New()
	..()
	switch(dir)
		if(SOUTH)
			initialize_directions = SOUTH
		if(NORTH)
			initialize_directions = NORTH
		if(WEST)
			initialize_directions = WEST
		if(EAST)
			initialize_directions = EAST
		if(NORTHEAST)
			initialize_directions = NORTH
		if(NORTHWEST)
			initialize_directions = WEST
		if(SOUTHEAST)
			initialize_directions = EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH
	initialize()


obj/machinery/atmospherics/pipe/up/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

obj/machinery/atmospherics/pipe/up/process()
	if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

obj/machinery/atmospherics/pipe/up/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

obj/machinery/atmospherics/pipe/up/proc/burst()
	src.visible_message("\red \bold [src] bursts!");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	del(src)

obj/machinery/atmospherics/pipe/up/proc/normalize_dir()
	if(dir==3)
		dir = 1
	else if(dir==12)
		dir = 4

obj/machinery/atmospherics/pipe/up/Del()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	..()

obj/machinery/atmospherics/pipe/up/pipeline_expansion()
	return list(node1, node2)

obj/machinery/atmospherics/pipe/up/update_icon()
/*	if(node1&&node2)
		var/C = ""
		icon_state = "intact[C][invisibility ? "-f" : "" ]"

		//var/node1_direction = get_dir(src, node1)
		//var/node2_direction = get_dir(src, node2)

		//dir = node1_direction|node2_direction

	else
		if(!node1&&!node2)
			world << "up-pipe deleted by update_icon()"
			del(src) //TODO: silent deleting looks weird
		var/have_node1 = node1?1:0
		var/have_node2 = node2?1:0
		icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"*/


obj/machinery/atmospherics/pipe/up/initialize()
	normalize_dir()
	var/node1_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	var/turf/controlerlocation = locate(1, 1, src.z)
	for(var/obj/effect/landmark/zcontroler/controler in controlerlocation)
		if(controler.up)
			var/turf/above = locate(src.x, src.y, controler.up_target)
			if(above)
				for(var/obj/machinery/atmospherics/target in above)
					if(target.initialize_directions && istype(target, /obj/machinery/atmospherics/pipe/down))
						node2 = target
						break


	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()
	//update_icon()

obj/machinery/atmospherics/pipe/up/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			del(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			del(parent)
		node2 = null

	update_icon()

	return null


///////////////////////
// and the down pipe //
///////////////////////

obj/machinery/atmospherics/pipe/down
		icon = 'code/TriDimension/multiz_pipe.dmi'
		icon_state = "down"

		name = "downwards pipe"
		desc = "A pipe segment to connect downwards."

		volume = 70

		dir = SOUTH
		initialize_directions = SOUTH

		var/obj/machinery/atmospherics/node1	//connection on the same Z
		var/obj/machinery/atmospherics/node2	//connection on the other Z

		var/minimum_temperature_difference = 300
		var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

		var/maximum_pressure = 70*ONE_ATMOSPHERE
		var/fatigue_pressure = 55*ONE_ATMOSPHERE
		alert_pressure = 55*ONE_ATMOSPHERE


		level = 1

obj/machinery/atmospherics/pipe/down/New()
	..()
	switch(dir)
		if(SOUTH)
			initialize_directions = SOUTH
		if(NORTH)
			initialize_directions = NORTH
		if(WEST)
			initialize_directions = WEST
		if(EAST)
			initialize_directions = EAST
		if(NORTHEAST)
			initialize_directions = NORTH
		if(NORTHWEST)
			initialize_directions = WEST
		if(SOUTHEAST)
			initialize_directions = EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH
	initialize()


obj/machinery/atmospherics/pipe/down/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

obj/machinery/atmospherics/pipe/down/process()
	if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

obj/machinery/atmospherics/pipe/down/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

obj/machinery/atmospherics/pipe/down/proc/burst()
	src.visible_message("\red \bold [src] bursts!");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	del(src)

obj/machinery/atmospherics/pipe/down/proc/normalize_dir()
	if(dir==3)
		dir = 1
	else if(dir==12)
		dir = 4

obj/machinery/atmospherics/pipe/down/Del()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	..()

obj/machinery/atmospherics/pipe/down/pipeline_expansion()
	return list(node1, node2)

obj/machinery/atmospherics/pipe/down/update_icon()
/*
	if(node1&&node2)
		var/C = ""
		icon_state = "intact[C][invisibility ? "-f" : "" ]"

		//var/node1_direction = get_dir(src, node1)
		//var/node2_direction = get_dir(src, node2)

		//dir = node1_direction|node2_direction

	else
		if(!node1&&!node2)
			del(src) //TODO: silent deleting looks weird
		var/have_node1 = node1?1:0
		var/have_node2 = node2?1:0
		icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"*/


obj/machinery/atmospherics/pipe/down/initialize()
	normalize_dir()
	var/node1_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	var/turf/controlerlocation = locate(1, 1, src.z)
	for(var/obj/effect/landmark/zcontroler/controler in controlerlocation)
		if(controler.down)
			var/turf/below = locate(src.x, src.y, controler.down_target)
			if(below)
				for(var/obj/machinery/atmospherics/target in below)
					if(target.initialize_directions && istype(target, /obj/machinery/atmospherics/pipe/up))
						node2 = target
						break


	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()
	//update_icon()

obj/machinery/atmospherics/pipe/down/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			del(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			del(parent)
		node2 = null

	update_icon()

	return null
