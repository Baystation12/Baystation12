/*CONTENTS
Buildable pipes
Buildable meters
*/

/obj/item/pipe
	name = "pipe"
	desc = "A pipe."
	var/pipe_type = 0
	var/pipename
	var/connect_types = CONNECT_TYPE_REGULAR
	force = 7
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "simple"
	randpixel = 5
	item_state = "buildpipe"
	w_class = ITEM_SIZE_NORMAL
	level = 2
	dir = SOUTH
	var/constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden
	var/pipe_class = PIPE_CLASS_BINARY

/obj/item/pipe/New(var/loc, var/obj/machinery/atmospherics/P)
	..()
	if(!P)
		return
	if(!P.dir)
		set_dir(2)
	else
		set_dir(P.dir)
	name = P.name
	desc = P.desc
	if(P.pipe_type < PIPE_UTILITY_START)//Utility pipes should not be adjusted.
		if(P.dir == WEST|NORTH|EAST || P.dir == NORTH|EAST|SOUTH || P.dir == EAST|SOUTH|WEST || P.dir == SOUTH|WEST|NORTH)			
			pipe_type = P.pipe_type			
		else if(P.dir != NORTH|SOUTH || P.dir != EAST|WEST)
			pipe_type = P.pipe_type + 1			
		else			
			pipe_type = P.pipe_type
	else		
		pipe_type = P.pipe_type

	connect_types = P.connect_types
	color = P.pipe_color
	icon = P.build_icon
	icon_state = P.build_icon_state
	pipe_class = P.pipe_class
	constructed_path = P.type

//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/simulated/floor/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target))
		user.unEquip(src, target)
	else
		return ..()

// rotate the pipe item clockwise

/obj/item/pipe/verb/rotate()
	set category = "Object"
	set name = "Rotate Pipe"
	set src in view(1)

	if (usr.stat || usr.restrained() || !Adjacent(usr) || usr.incapacitated())
		return

	src.set_dir(turn(src.dir, -90))

	if (pipe_type in list (PIPE_SIMPLE_STRAIGHT, PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_UNIVERSAL, PIPE_HE_STRAIGHT, PIPE_MVALVE, PIPE_DVALVE, PIPE_SVALVE, PIPE_FUEL_STRAIGHT))
		if(dir==2)
			set_dir(1)
		else if(dir==8)
			set_dir(4)
	else if (pipe_type in list (PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_FUEL_MANIFOLD4W))
		set_dir(2)

	return

/obj/item/pipe/AltClick()
	rotate()

/obj/item/pipe/Move()
	..()
	if ((pipe_type in list (PIPE_SIMPLE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT, PIPE_HE_BENT, PIPE_FUEL_BENT))	&& (src.dir in GLOB.cardinal))
		src.set_dir(src.dir|turn(src.dir, 90))
	else if (pipe_type in list (PIPE_SIMPLE_STRAIGHT, PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_UNIVERSAL, PIPE_HE_STRAIGHT, PIPE_MVALVE, PIPE_DVALVE, PIPE_SVALVE, PIPE_FUEL_STRAIGHT))
		if(dir==2)
			set_dir(1)
		else if(dir==8)
			set_dir(4)
	return

// returns all pipe's endpoints

/obj/item/pipe/proc/get_pipe_dir()
	if (!dir)
		return 0
	var/flip = turn(dir, 180)
	var/cw = turn(dir, -90)
	var/acw = turn(dir, 90)

	switch(pipe_type)
		if(	PIPE_SIMPLE_STRAIGHT, PIPE_HE_STRAIGHT, PIPE_JUNCTION ,	PIPE_PUMP ,	PIPE_VOLUME_PUMP , PIPE_PASSIVE_GATE ,	PIPE_MVALVE, PIPE_DVALVE, PIPE_SVALVE,\
			PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_UNIVERSAL, PIPE_FUEL_STRAIGHT)
			return dir|flip
		if(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER, PIPE_FUEL_MANIFOLD4W)
			return dir|flip|cw|acw
		if(PIPE_MANIFOLD, PIPE_SUPPLY_MANIFOLD, PIPE_SCRUBBERS_MANIFOLD, PIPE_FUEL_MANIFOLD)
			return flip|cw|acw
		if(PIPE_MTVALVE)
			return dir|flip|cw
		if(PIPE_MTVALVEM)
			return dir|flip|acw
		else
			return dir
	return 0

/obj/item/pipe/proc/get_pdir() //endpoints for regular pipes
	var/flip = turn(dir, 180)

	if (!(pipe_type in list(PIPE_HE_STRAIGHT, PIPE_HE_BENT, PIPE_JUNCTION)))
		return get_pipe_dir()
	switch(pipe_type)
		if(PIPE_HE_STRAIGHT,PIPE_HE_BENT)
			return 0
		if(PIPE_JUNCTION)
			return flip
	return 0

// return the h_dir (heat-exchange pipes) from the type and the dir

/obj/item/pipe/proc/get_hdir() //endpoints for h/e pipes
	switch(pipe_type)
		if(PIPE_HE_STRAIGHT)
			return get_pipe_dir()
		if(PIPE_HE_BENT)
			return get_pipe_dir()
		if(PIPE_JUNCTION)
			return dir
		else
			return 0

/obj/item/pipe/attack_self(mob/user as mob)
	return rotate()

/obj/item/pipe/proc/build_unary(var/obj/machinery/atmospherics/unary/P, var/pipefailtext)
	P.atmos_init()
	if (QDELETED(P))
		to_chat(usr, pipefailtext)
		return 1
	P.build_network()
	if(P.node)		
		P.node.atmos_init()
		P.node.build_network()
	return 0

/obj/item/pipe/proc/build_binary(var/obj/machinery/atmospherics/pipe/simple/P, var/pipefailtext)
	P.atmos_init()
	if (QDELETED(P))
		to_chat(usr, pipefailtext)
		return 1
	P.build_network()
	if(P.node1)
		P.node1.atmos_init()
		P.node1.build_network()
	if(P.node2)
		P.node2.atmos_init()
		P.node2.build_network()
	return 0

/obj/item/pipe/proc/build_trinary(var/obj/machinery/atmospherics/pipe/manifold/P, var/pipefailtext)
	P.atmos_init()
	if (QDELETED(P))
		to_chat(usr, pipefailtext)
		return 1
	log_and_message_admins("Building network...")
	P.build_network()
	log_and_message_admins("node1: [P.node1]")
	log_and_message_admins("node2: [P.node2]")
	log_and_message_admins("node3: [P.node3]")
	if(P.node1)
		log_and_message_admins("Building node 1 network...")
		P.node1.atmos_init()
		P.node1.build_network()
	if(P.node2)
		log_and_message_admins("Building node 2 network...")
		P.node2.atmos_init()
		P.node2.build_network()
	if(P.node3)
		log_and_message_admins("Building node 3 network...")
		P.node3.atmos_init()
		P.node3.build_network()
	return 0

/obj/item/pipe/proc/build_quaternary(var/obj/machinery/atmospherics/pipe/manifold4w/P, var/pipefailtext)
	P.atmos_init()
	if (QDELETED(P))
		to_chat(usr, pipefailtext)
		return 1
	P.build_network()
	if(P.node1)
		P.node1.atmos_init()
		P.node1.build_network()
	if(P.node2)
		P.node2.atmos_init()
		P.node2.build_network()
	if(P.node3)
		P.node3.atmos_init()
		P.node3.build_network()
	if(P.node4)
		P.node4.atmos_init()
		P.node4.build_network()
	return 0

/obj/item/pipe/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	. = ..()
	//*
	if(!isWrench(W))
		return ..()
	if (!isturf(src.loc))
		return 1
	if (pipe_type in list (PIPE_SIMPLE_STRAIGHT, PIPE_SUPPLY_STRAIGHT, PIPE_SCRUBBERS_STRAIGHT, PIPE_HE_STRAIGHT, PIPE_MVALVE, PIPE_DVALVE, PIPE_SVALVE, PIPE_FUEL_STRAIGHT))
		if(dir==2)
			set_dir(1)
		else if(dir==8)
			set_dir(4)
	else if (pipe_type in list(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER, PIPE_FUEL_MANIFOLD4W))
		set_dir(2)
	var/pipe_dir = get_pipe_dir()

	for(var/obj/machinery/atmospherics/M in src.loc)
		if((M.initialize_directions & pipe_dir) && M.check_connect_types_construction(M,src))	// matches at least one direction on either type of pipe & same connection type
			to_chat(user, "<span class='warning'>There is already a pipe of the same type at this location.</span>")
			return 1
	// no conflicts found

	var/pipefailtext = "<span class='warning'>There's nothing to connect this pipe section to!</span>" //(with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)"

	//TODO: Move all of this stuff into the various pipe constructors.
	var/obj/machinery/atmospherics/P = new constructed_path(src)

	P.pipe_color = color
	P.set_dir(dir)
	P.initialize_directions = pipe_dir
	P.loc = loc //fixes issue with location not being set correctly.

	if(P.pipe_type == PIPE_TANK)
		P.level = 1//Tanks are always on top.
	else
		var/turf/T = P.loc
		P.level = (!T.is_plating() ? 2 : 1)

	if(P.pipe_class == PIPE_CLASS_UNARY)
		if(build_unary(P, pipefailtext))
			return 1

	if(P.pipe_class == PIPE_CLASS_BINARY)
		if(build_binary(P, pipefailtext))
			return 1

	if(P.pipe_class == PIPE_CLASS_TRINARY)
		if(build_trinary(P, pipefailtext))
			return 1

	if(P.pipe_class == PIPE_CLASS_QUATERNARY)
		if(build_quaternary(P, pipefailtext))
			return 1

	if(P.pipe_class == PIPE_CLASS_OMNI)
		P.atmos_init()
		P.build_network()

	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user.visible_message( \
		"[user] fastens the [src].", \
		"<span class='notice'>You have fastened the [src].</span>", \
		"You hear ratchet.")
	qdel(src)	// remove the pipe item

	return

/obj/item/pipe/injector
	name = "Injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."
	pipe_type = PIPE_INJECTOR
	connect_types =  CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	icon = 	'icons/atmos/injector.dmi'
	icon_state = "map_injector"
	constructed_path = /obj/machinery/atmospherics/unary/outlet_injector
	pipe_class = PIPE_CLASS_UNARY

	var/frequency
	var/id

/obj/item/pipe/injector/New(loc, obj/machinery/atmospherics/P)
	..(loc, null)
	var/obj/machinery/atmospherics/unary/outlet_injector/I = P
	if(!I)
		return
	frequency = I.frequency
	id = I.id
	set_dir(I.dir)
	name = I.name
	desc = I.desc
	pipe_type = I.pipe_type
	connect_types = I.connect_types

/obj/item/pipe_meter
	name = "meter"
	desc = "A meter that can measure gas inside pipes or in the general area."
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = ITEM_SIZE_LARGE
	var/constructed_path = /obj/machinery/meter

/obj/item/pipe_meter/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()

	if(!isWrench(W))
		return ..()
	if(!locate(/obj/machinery/atmospherics/pipe, src.loc))	
		new /obj/machinery/meter/turf(loc)
		to_chat(user, "<span class='notice'>You have fastened the meter to the [loc].</span>")
	else
		new/obj/machinery/meter(loc)
		to_chat(user, "<span class='notice'>You have fastened the meter to the pipe.</span>")
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		
	qdel(src)

/obj/item/air_sensor
	name = "gas sensor"
	desc = "A sensor. It detects gasses."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	w_class = ITEM_SIZE_LARGE
	var/frequency = 1441
	var/output = 3
	var/id_tag

/obj/item/air_sensor/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()
	if(!isWrench(W))
		return ..()
	var/obj/machinery/air_sensor/sensor = new /obj/machinery/air_sensor(src.loc)
	sensor.frequency = frequency
	sensor.set_frequency(frequency)
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You have fastened the [src].</span>")
	qdel(src)