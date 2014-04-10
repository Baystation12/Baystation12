obj/machinery/atmospherics/pipe

	var/datum/gas_mixture/air_temporary //used when reconstructing a pipeline that broke
	var/datum/pipeline/parent

	var/volume = 0
	force = 20

	layer = 2.4 //under wires with their 2.44
	use_power = 0

	var/alert_pressure = 80*ONE_ATMOSPHERE
		//minimum pressure before check_pressure(...) should be called

obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return null

obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	//Return 1 if parent should continue checking other pipes
	//Return null if parent should stop checking other pipes. Recall: del(src) will by default return null

	return 1

obj/machinery/atmospherics/pipe/return_air()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air

obj/machinery/atmospherics/pipe/build_network()
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()

obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)

obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(!parent)
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)

obj/machinery/atmospherics/pipe/Del()
	del(parent)
	if(air_temporary)
		loc.assume_air(air_temporary)

	..()

obj/machinery/atmospherics/pipe/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()
	if (istype(src, /obj/machinery/atmospherics/pipe/vent))
		return ..()

	if(istype(W,/obj/item/device/pipe_painter))
		return 0

	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	var/turf/T = src.loc
	if (level==1 && isturf(T) && T.intact)
		user << "\red You must remove the plating first."
		return 1
	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > 2*ONE_ATMOSPHERE)
		user << "<span class='warning'>You cannot unwrench [src], it is too exerted due to internal pressure.</span>"
		add_fingerprint(user)
		return 1
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user << "\blue You begin to unfasten \the [src]..."
	if (do_after(user, 40))
		user.visible_message( \
			"[user] unfastens \the [src].", \
			"\blue You have unfastened \the [src].", \
			"You hear ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.target == src)
				new /obj/item/pipe_meter(T)
				del(meter)
		del(src)


obj/machinery/atmospherics/pipe/simple
	icon = 'icons/obj/pipes.dmi'

	name = "pipe"
	desc = "A one meter section of regular pipe"

	volume = 70

	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	var/maximum_pressure = 70*ONE_ATMOSPHERE
	var/fatigue_pressure = 55*ONE_ATMOSPHERE
	alert_pressure = 55*ONE_ATMOSPHERE


	level = 1

obj/machinery/atmospherics/pipe/simple/New()
	..()
	alpha = 255
	switch(dir)
		if(SOUTH || NORTH)
			initialize_directions = SOUTH|NORTH
		if(EAST || WEST)
			initialize_directions = EAST|WEST
		if(NORTHEAST)
			initialize_directions = NORTH|EAST
		if(NORTHWEST)
			initialize_directions = NORTH|WEST
		if(SOUTHEAST)
			initialize_directions = SOUTH|EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH|WEST


obj/machinery/atmospherics/pipe/simple/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

obj/machinery/atmospherics/pipe/simple/process()
	if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

	/*if(!node1)
		parent.mingle_with_turf(loc, volume)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1

	else if(!node2)
		parent.mingle_with_turf(loc, volume)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (nodealert)
		nodealert = 0


	else if(parent)
		var/environment_temperature = 0

		if(istype(loc, /turf/simulated/))
			if(loc:blocks_air)
				environment_temperature = loc:temperature
			else
				var/datum/gas_mixture/environment = loc.return_air()
				environment_temperature = environment.temperature

		else
			environment_temperature = loc:temperature

		var/datum/gas_mixture/pipe_air = return_air()

		if(abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference)
			parent.temperature_interact(loc, volume, thermal_conductivity)
	*/  //Screw you heat lag

obj/machinery/atmospherics/pipe/simple/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

obj/machinery/atmospherics/pipe/simple/proc/burst()
	src.visible_message("\red \bold [src] bursts!");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	del(src)

obj/machinery/atmospherics/pipe/simple/proc/normalize_dir()
	if(dir==3)
		dir = 1
	else if(dir==12)
		dir = 4

obj/machinery/atmospherics/pipe/simple/Del()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)

	..()

obj/machinery/atmospherics/pipe/simple/pipeline_expansion()
	return list(node1, node2)

obj/machinery/atmospherics/pipe/simple/update_icon()
	if(node1&&node2)
		switch(pipe_color)
			if ("red") color = COLOR_RED
			if ("blue") color = COLOR_BLUE
			if ("cyan") color = COLOR_CYAN
			if ("green") color = COLOR_GREEN
			if ("yellow") color = "#FFCC00"
			if ("purple") color = "#5C1EC0"
			if ("grey") color = null
		icon_state = "intact[invisibility ? "-f" : "" ]"

		//var/node1_direction = get_dir(src, node1)
		//var/node2_direction = get_dir(src, node2)

		//dir = node1_direction|node2_direction

	else
		if(!node1&&!node2)
			del(src) //TODO: silent deleting looks weird
		var/have_node1 = node1?1:0
		var/have_node2 = node2?1:0
		icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"


obj/machinery/atmospherics/pipe/simple/initialize()
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src,node2_dir))
		if(target.initialize_directions & get_dir(target,src))
			node2 = target
			break


	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()
	//update_icon()

obj/machinery/atmospherics/pipe/simple/disconnect(obj/machinery/atmospherics/reference)
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




obj/machinery/atmospherics/pipe/simple/visible
	level = 2
	icon_state = "intact"

obj/machinery/atmospherics/pipe/simple/visible/scrubbers
	name="Scrubbers pipe"
	color=COLOR_RED

obj/machinery/atmospherics/pipe/simple/visible/supply
	name="Air supply pipe"
	color=COLOR_BLUE

obj/machinery/atmospherics/pipe/simple/visible/yellow
	color="#FFCC00"

obj/machinery/atmospherics/pipe/simple/visible/cyan
	color=COLOR_CYAN

obj/machinery/atmospherics/pipe/simple/visible/green
	color=COLOR_GREEN


obj/machinery/atmospherics/pipe/simple/hidden
	level = 1
	icon_state = "intact-f"
	alpha = 192		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name="Scrubbers pipe"
	color=COLOR_RED

obj/machinery/atmospherics/pipe/simple/hidden/supply
	name="Air supply pipe"
	color=COLOR_BLUE

obj/machinery/atmospherics/pipe/simple/hidden/yellow
	color="#FFCC00"

obj/machinery/atmospherics/pipe/simple/hidden/cyan
	color=COLOR_CYAN

obj/machinery/atmospherics/pipe/simple/hidden/green
	color=COLOR_GREEN


obj/machinery/atmospherics/pipe/simple/insulated
	icon = 'icons/obj/atmospherics/red_pipe.dmi'
	icon_state = "intact"

	minimum_temperature_difference = 10000
	thermal_conductivity = 0
	maximum_pressure = 1000*ONE_ATMOSPHERE
	fatigue_pressure = 900*ONE_ATMOSPHERE
	alert_pressure = 900*ONE_ATMOSPHERE

	level = 2


obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/obj/atmospherics/pipe_manifold.dmi'

	name = "pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = 105

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2
	var/obj/machinery/atmospherics/node3

	level = 1
	layer = 2.4 //under wires with their 2.44

obj/machinery/atmospherics/pipe/manifold/New()
	alpha = 255
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|SOUTH|WEST
		if(SOUTH)
			initialize_directions = WEST|NORTH|EAST
		if(EAST)
			initialize_directions = SOUTH|WEST|NORTH
		if(WEST)
			initialize_directions = NORTH|EAST|SOUTH

	..()



obj/machinery/atmospherics/pipe/manifold/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

obj/machinery/atmospherics/pipe/manifold/pipeline_expansion()
	return list(node1, node2, node3)

obj/machinery/atmospherics/pipe/manifold/process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL
/*
	if(!node1)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if(!node2)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if(!node3)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/
obj/machinery/atmospherics/pipe/manifold/Del()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	if(node3)
		node3.disconnect(src)

	..()

obj/machinery/atmospherics/pipe/manifold/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			del(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			del(parent)
		node2 = null

	if(reference == node3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			del(parent)
		node3 = null

	update_icon()

	..()

obj/machinery/atmospherics/pipe/manifold/update_icon()
	if(node1&&node2&&node3)
		switch(pipe_color)
			if ("red") color = COLOR_RED
			if ("blue") color = COLOR_BLUE
			if ("cyan") color = COLOR_CYAN
			if ("green") color = COLOR_GREEN
			if ("yellow") color = "#FFCC00"
			if ("purple") color = "#5C1EC0"
			if ("grey") color = null
		icon_state = "manifold[invisibility ? "-f" : "" ]"

	else
		var/connected = 0
		var/unconnected = 0
		var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

		if(node1)
			connected |= get_dir(src, node1)
		if(node2)
			connected |= get_dir(src, node2)
		if(node3)
			connected |= get_dir(src, node3)

		unconnected = (~connected)&(connect_directions)

		icon_state = "manifold_[connected]_[unconnected]"

		if(!connected)
			del(src)

	return

obj/machinery/atmospherics/pipe/manifold/initialize()
	var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					node1 = target
					connect_directions &= ~direction
					break
			if (node1)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					node2 = target
					connect_directions &= ~direction
					break
			if (node2)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					node3 = target
					connect_directions &= ~direction
					break
			if (node3)
				break

	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)
	//update_icon()
	update_icon()


obj/machinery/atmospherics/pipe/manifold/visible
	level = 2
	icon_state = "manifold"

obj/machinery/atmospherics/pipe/manifold/visible/supply
	name="Air supply pipe"
	color=COLOR_BLUE

obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name="Scrubbers pipe"
	color=COLOR_RED

obj/machinery/atmospherics/pipe/manifold/visible/yellow
	color="#FFCC00"

obj/machinery/atmospherics/pipe/manifold/visible/cyan
	color=COLOR_CYAN

obj/machinery/atmospherics/pipe/manifold/visible/green
	color=COLOR_GREEN


obj/machinery/atmospherics/pipe/manifold/hidden
	level = 1
	icon_state = "manifold-f"
	alpha = 192		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name="Air supply pipe"
	color=COLOR_BLUE

obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name="Scrubbers pipe"
	color = COLOR_RED

obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	color="#FFCC00"

obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	color=COLOR_CYAN

obj/machinery/atmospherics/pipe/manifold/hidden/green
	color=COLOR_GREEN



obj/machinery/atmospherics/pipe/manifold4w
	icon = 'icons/obj/atmospherics/pipe_manifold.dmi'

	name = "4-way pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = 140

	dir = SOUTH
	initialize_directions = NORTH|SOUTH|EAST|WEST

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2
	var/obj/machinery/atmospherics/node3
	var/obj/machinery/atmospherics/node4

	level = 1
	layer = 2.4 //under wires with their 2.44

obj/machinery/atmospherics/pipe/manifold4w/New()
	..()
	alpha = 255

obj/machinery/atmospherics/pipe/manifold4w/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

obj/machinery/atmospherics/pipe/manifold4w/pipeline_expansion()
	return list(node1, node2, node3, node4)

obj/machinery/atmospherics/pipe/manifold4w/process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL
/*
	if(!node1)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if(!node2)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if(!node3)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/
obj/machinery/atmospherics/pipe/manifold4w/Del()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	if(node3)
		node3.disconnect(src)
	if(node4)
		node4.disconnect(src)

	..()

obj/machinery/atmospherics/pipe/manifold4w/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			del(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			del(parent)
		node2 = null

	if(reference == node3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			del(parent)
		node3 = null

	if(reference == node4)
		if(istype(node4, /obj/machinery/atmospherics/pipe))
			del(parent)
		node4 = null

	update_icon()

	..()

obj/machinery/atmospherics/pipe/manifold4w/update_icon()
	overlays.Cut()
	if(node1&&node2&&node3&&node4)
		switch(pipe_color)
			if ("red") color = COLOR_RED
			if ("blue") color = COLOR_BLUE
			if ("cyan") color = COLOR_CYAN
			if ("green") color = COLOR_GREEN
			if ("yellow") color = "#FFCC00"
			if ("purple") color = "#5C1EC0"
			if ("grey") color = null
		icon_state = "manifold4w[invisibility ? "-f" : "" ]"

	else
		icon_state = "manifold4w_ex"
		var/icon/con = new/icon('icons/obj/atmospherics/pipe_manifold.dmi',"manifold4w_con") //Since 4-ways are supposed to be directionless, they need an overlay instead it seems.

		if(node1)
			overlays += new/image(con,dir=1)
		if(node2)
			overlays += new/image(con,dir=2)
		if(node3)
			overlays += new/image(con,dir=4)
		if(node4)
			overlays += new/image(con,dir=8)

		if(!node1 && !node2 && !node3 && !node4)
			del(src)
	return

obj/machinery/atmospherics/pipe/manifold4w/initialize()

	for(var/obj/machinery/atmospherics/target in get_step(src,1))
		if(target.initialize_directions & 2)
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,2))
		if(target.initialize_directions & 1)
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,4))
		if(target.initialize_directions & 8)
			node3 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src,8))
		if(target.initialize_directions & 4)
			node4 = target
			break

	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)
	//update_icon()
	update_icon()


obj/machinery/atmospherics/pipe/manifold4w/visible
	level = 2
	icon_state = "manifold4w"

obj/machinery/atmospherics/pipe/manifold4w/visible/supply
	name="Air supply pipe"
	color=COLOR_BLUE

obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers
	name="Scrubbers pipe"
	color=COLOR_RED

obj/machinery/atmospherics/pipe/manifold4w/visible/yellow
	color="#FFCC00"

obj/machinery/atmospherics/pipe/manifold4w/visible/cyan
	color=COLOR_CYAN

obj/machinery/atmospherics/pipe/manifold4w/visible/green
	color=COLOR_GREEN


obj/machinery/atmospherics/pipe/manifold4w/hidden
	level = 1
	icon_state = "manifold4w-f"
	alpha = 192		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	name="Air supply pipe"
	color=COLOR_BLUE

obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	name="Scrubbers pipe"
	color=COLOR_RED

obj/machinery/atmospherics/pipe/manifold4w/hidden/yellow
	color="#FFCC00"

obj/machinery/atmospherics/pipe/manifold4w/hidden/cyan
	color=COLOR_CYAN

obj/machinery/atmospherics/pipe/manifold4w/hidden/green
	color=COLOR_GREEN


obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes"
	icon = 'icons/obj/pipes.dmi'
	icon_state = "cap"
	level = 2
	layer = 2.4 //under wires with their 2.44

	volume = 35

	dir = SOUTH
	initialize_directions = NORTH

	var/obj/machinery/atmospherics/node

obj/machinery/atmospherics/pipe/cap/New()
	..()
	switch(dir)
		if(SOUTH)
		 initialize_directions = NORTH
		if(NORTH)
		 initialize_directions = SOUTH
		if(WEST)
		 initialize_directions = EAST
		if(EAST)
		 initialize_directions = WEST

obj/machinery/atmospherics/pipe/cap/hide(var/i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

obj/machinery/atmospherics/pipe/cap/pipeline_expansion()
	return list(node)

obj/machinery/atmospherics/pipe/cap/process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL
obj/machinery/atmospherics/pipe/cap/Del()
	if(node)
		node.disconnect(src)

	..()

obj/machinery/atmospherics/pipe/cap/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node)
		if(istype(node, /obj/machinery/atmospherics/pipe))
			del(parent)
		node = null

	update_icon()

	..()

obj/machinery/atmospherics/pipe/cap/update_icon()
	overlays = new()

	icon_state = "cap[invisibility ? "-f" : ""]"
	return

obj/machinery/atmospherics/pipe/cap/initialize()
	for(var/obj/machinery/atmospherics/target in get_step(src, dir))
		if(target.initialize_directions & get_dir(target,src))
			node = target
			break

	var/turf/T = src.loc			// hide if turf is not intact
	hide(T.intact)
	//update_icon()
	update_icon()

obj/machinery/atmospherics/pipe/cap/visible
	level = 2
	icon_state = "cap"

obj/machinery/atmospherics/pipe/cap/hidden
	level = 1
	icon_state = "cap-f"


obj/machinery/atmospherics/pipe/tank
	icon = 'icons/obj/atmospherics/pipe_tank.dmi'
	icon_state = "intact"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	volume = 2000 //in liters, 1 meters by 1 meters by 2 meters

	dir = SOUTH
	initialize_directions = SOUTH
	density = 1

	var/obj/machinery/atmospherics/node1

obj/machinery/atmospherics/pipe/tank/New()
	initialize_directions = dir
	..()

obj/machinery/atmospherics/pipe/tank/process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL
/*			if(!node1)
		parent.mingle_with_turf(loc, 200)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/
obj/machinery/atmospherics/pipe/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"

	New()
		air_temporary = new
		air_temporary.volume = volume
		air_temporary.temperature = T20C

		air_temporary.carbon_dioxide = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

		..()

obj/machinery/atmospherics/pipe/tank/toxins
	icon = 'icons/obj/atmospherics/orange_pipe_tank.dmi'
	name = "Pressure Tank (Phoron)"

	New()
		air_temporary = new
		air_temporary.volume = volume
		air_temporary.temperature = T20C

		air_temporary.toxins = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

		..()

obj/machinery/atmospherics/pipe/tank/oxygen_agent_b
	icon = 'icons/obj/atmospherics/red_orange_pipe_tank.dmi'
	name = "Pressure Tank (Oxygen + Phoron)"

	New()
		air_temporary = new
		air_temporary.volume = volume
		air_temporary.temperature = T0C

		var/datum/gas/oxygen_agent_b/trace_gas = new
		trace_gas.moles = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

		air_temporary.trace_gases += trace_gas

		..()

obj/machinery/atmospherics/pipe/tank/oxygen
	icon = 'icons/obj/atmospherics/blue_pipe_tank.dmi'
	name = "Pressure Tank (Oxygen)"

	New()
		air_temporary = new
		air_temporary.volume = volume
		air_temporary.temperature = T20C

		air_temporary.oxygen = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

		..()

obj/machinery/atmospherics/pipe/tank/nitrogen
	icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
	name = "Pressure Tank (Nitrogen)"

	New()
		air_temporary = new
		air_temporary.volume = volume
		air_temporary.temperature = T20C

		air_temporary.nitrogen = (25*ONE_ATMOSPHERE)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

		..()

obj/machinery/atmospherics/pipe/tank/air
	icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
	name = "Pressure Tank (Air)"

	New()
		air_temporary = new
		air_temporary.volume = volume
		air_temporary.temperature = T20C

		air_temporary.oxygen = (25*ONE_ATMOSPHERE*O2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)
		air_temporary.nitrogen = (25*ONE_ATMOSPHERE*N2STANDARD)*(air_temporary.volume)/(R_IDEAL_GAS_EQUATION*air_temporary.temperature)

		..()

obj/machinery/atmospherics/pipe/tank/Del()
	if(node1)
		node1.disconnect(src)

	..()

obj/machinery/atmospherics/pipe/tank/pipeline_expansion()
	return list(node1)

obj/machinery/atmospherics/pipe/tank/update_icon()
	if(node1)
		icon_state = "intact"

		dir = get_dir(src, node1)

	else
		icon_state = "exposed"

obj/machinery/atmospherics/pipe/tank/initialize()

	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	update_icon()

obj/machinery/atmospherics/pipe/tank/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			del(parent)
		node1 = null

	update_icon()

	return null

obj/machinery/atmospherics/pipe/tank/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/device/analyzer) && get_dist(user, src) <= 1)
		for (var/mob/O in viewers(user, null))
			O << "\red [user] has used the analyzer on \icon[icon]"

		var/pressure = parent.air.return_pressure()
		var/total_moles = parent.air.total_moles()

		user << "\blue Results of analysis of \icon[icon]"
		if (total_moles>0)
			var/o2_concentration = parent.air.oxygen/total_moles
			var/n2_concentration = parent.air.nitrogen/total_moles
			var/co2_concentration = parent.air.carbon_dioxide/total_moles
			var/phoron_concentration = parent.air.toxins/total_moles

			var/unknown_concentration =  1-(o2_concentration+n2_concentration+co2_concentration+phoron_concentration)

			user << "\blue Pressure: [round(pressure,0.1)] kPa"
			user << "\blue Nitrogen: [round(n2_concentration*100)]%"
			user << "\blue Oxygen: [round(o2_concentration*100)]%"
			user << "\blue CO2: [round(co2_concentration*100)]%"
			user << "\blue Phoron: [round(phoron_concentration*100)]%"
			if(unknown_concentration>0.01)
				user << "\red Unknown: [round(unknown_concentration*100)]%"
			user << "\blue Temperature: [round(parent.air.temperature-T0C)]&deg;C"
		else
			user << "\blue Tank is empty!"

obj/machinery/atmospherics/pipe/vent
	icon = 'icons/obj/atmospherics/pipe_vent.dmi'
	icon_state = "intact"

	name = "Vent"
	desc = "A large air vent"

	level = 1

	volume = 250

	dir = SOUTH
	initialize_directions = SOUTH

	var/build_killswitch = 1

	var/obj/machinery/atmospherics/node1

obj/machinery/atmospherics/pipe/vent/New()
	initialize_directions = dir
	..()

obj/machinery/atmospherics/pipe/vent/high_volume
	name = "Larger vent"
	volume = 1000

obj/machinery/atmospherics/pipe/vent/process()
	if(!parent)
		if(build_killswitch <= 0)
			. = PROCESS_KILL
		else
			build_killswitch--
		..()
		return
	else
		parent.mingle_with_turf(loc, volume)
/*
	if(!node1)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/
obj/machinery/atmospherics/pipe/vent/Del()
	if(node1)
		node1.disconnect(src)

	..()

obj/machinery/atmospherics/pipe/vent/pipeline_expansion()
	return list(node1)

obj/machinery/atmospherics/pipe/vent/update_icon()
	if(node1)
		icon_state = "intact"

		dir = get_dir(src, node1)

	else
		icon_state = "exposed"

obj/machinery/atmospherics/pipe/vent/initialize()
	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,connect_direction))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	update_icon()

obj/machinery/atmospherics/pipe/vent/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			del(parent)
		node1 = null

	update_icon()

	return null

obj/machinery/atmospherics/pipe/vent/hide(var/i) //to make the little pipe section invisible, the icon changes.
	if(node1)
		icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]intact"
		dir = get_dir(src, node1)
	else
		icon_state = "exposed"
