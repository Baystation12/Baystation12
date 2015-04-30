////////////////////////////
// parent class for pipes //
////////////////////////////
obj/machinery/atmospherics/pipe/zpipe
		icon = 'icons/obj/structures.dmi'
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

obj/machinery/atmospherics/pipe/zpipe/New()
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

obj/machinery/atmospherics/pipe/zpipe/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

obj/machinery/atmospherics/pipe/up/process()
	if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

obj/machinery/atmospherics/pipe/zpipe/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

obj/machinery/atmospherics/pipe/zpipe/proc/burst()
	src.visible_message("\red \bold [src] bursts!");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	qdel(src) // NOT qdel.

obj/machinery/atmospherics/pipe/zpipe/proc/normalize_dir()
	if(dir==3)
		set_dir(1)
	else if(dir==12)
		set_dir(4)

obj/machinery/atmospherics/pipe/zpipe/Destroy()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	..()

obj/machinery/atmospherics/pipe/zpipe/pipeline_expansion()
	return list(node1, node2)

obj/machinery/atmospherics/pipe/zpipe/update_icon()
	return

obj/machinery/atmospherics/pipe/zpipe/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 = null

	return null
/////////////////////////
// the elusive up pipe //
/////////////////////////
obj/machinery/atmospherics/pipe/zpipe/up
		icon = 'icons/obj/structures.dmi'
		icon_state = "up"

		name = "upwards pipe"
		desc = "A pipe segment to connect upwards."

obj/machinery/atmospherics/pipe/zpipe/up/initialize()
	normalize_dir()
	var/node1_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break

	var/turf/controllerlocation = locate(1, 1, src.z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.up)
			var/turf/above = locate(src.x, src.y, controller.up_target)
			if(above)
				for(var/obj/machinery/atmospherics/target in above)
					if(target.initialize_directions && istype(target, /obj/machinery/atmospherics/pipe/zpipe/down))
						if (check_connect_types(target,src))
							node2 = target
							break


	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)

///////////////////////
// and the down pipe //
///////////////////////

obj/machinery/atmospherics/pipe/zpipe/down
		icon = 'icons/obj/structures.dmi'
		icon_state = "down"

		name = "downwards pipe"
		desc = "A pipe segment to connect downwards."

obj/machinery/atmospherics/pipe/zpipe/down/initialize()
	normalize_dir()
	var/node1_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break

	var/turf/controllerlocation = locate(1, 1, src.z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.down)
			var/turf/below = locate(src.x, src.y, controller.down_target)
			if(below)
				for(var/obj/machinery/atmospherics/target in below)
					if(target.initialize_directions && istype(target, /obj/machinery/atmospherics/pipe/zpipe/up))
						if (check_connect_types(target,src))
							node2 = target
							break


	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)

///////////////////////
// supply/scrubbers  //
///////////////////////

obj/machinery/atmospherics/pipe/zpipe/up/scrubbers
	icon_state = "up-scrubbers"
	name = "upwards scrubbers pipe"
	desc = "A scrubbers pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

obj/machinery/atmospherics/pipe/zpipe/up/supply
	icon_state = "up-supply"
	name = "upwards supply pipe"
	desc = "A supply pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

obj/machinery/atmospherics/pipe/zpipe/down/scrubbers
	icon_state = "down-scrubbers"
	name = "downwards scrubbers pipe"
	desc = "A scrubbers pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 2.38
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

obj/machinery/atmospherics/pipe/zpipe/down/supply
	icon_state = "down-supply"
	name = "downwards supply pipe"
	desc = "A supply pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 2.39
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE
