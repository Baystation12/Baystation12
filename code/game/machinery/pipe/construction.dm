/*CONTENTS
Buildable pipes
Buildable meters
*/

/obj/item/pipe
	name = "pipe"
	desc = "A pipe."
	var/pipename
	var/connect_types = CONNECT_TYPE_REGULAR
	force = 7
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "simple"
	randpixel = 5
	item_state = "buildpipe"
	w_class = ITEM_SIZE_NORMAL
	level = 2
	obj_flags = OBJ_FLAG_ROTATABLE 
	dir = SOUTH
	var/constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden
	var/pipe_class = PIPE_CLASS_BINARY
	var/rotate_class = PIPE_ROTATE_STANDARD

/obj/item/pipe/Initialize(var/mapload, var/obj/machinery/atmospherics/P)
	. = ..()
	if(!P)
		return
	if(!P.dir)
		set_dir(SOUTH)
	else
		set_dir(P.dir)
	SetName(P.name)
	desc = P.desc

	connect_types = P.connect_types
	color = P.pipe_color
	icon = P.build_icon
	icon_state = P.build_icon_state
	pipe_class = P.pipe_class
	rotate_class = P.rotate_class
	constructed_path = P.type

//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/simulated/floor/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target))
		user.unEquip(src, target)
	else
		return ..()

/obj/item/pipe/rotate(mob/user)
	. = ..()
	sanitize_dir()

/obj/item/pipe/Move()
	var/old_dir = dir
	. = ..()
	set_dir(old_dir)

/obj/item/pipe/proc/sanitize_dir()
	switch(rotate_class)
		if(PIPE_ROTATE_TWODIR)
			if(dir==2)
				set_dir(1)
			else if(dir==8)
				set_dir(4)
		if(PIPE_ROTATE_ONEDIR)
			set_dir(2)

/obj/item/pipe/attack_self(mob/user as mob)
	return rotate(user)

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

/obj/item/pipe/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(!isWrench(W))
		return ..()
	if (!isturf(loc))
		return 1

	sanitize_dir()
	var/obj/machinery/atmospherics/fake_machine = constructed_path
	var/pipe_dir = base_pipe_initialize_directions(dir, initial(fake_machine.connect_dir_type))

	for(var/obj/machinery/atmospherics/M in loc)
		if((M.initialize_directions & pipe_dir) && M.check_connect_types_construction(M,src))	// matches at least one direction on either type of pipe & same connection type
			to_chat(user, "<span class='warning'>There is already a pipe of the same type at this location.</span>")
			return 1
	// no conflicts found

	var/pipefailtext = "<span class='warning'>There's nothing to connect this pipe section to!</span>" //(with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)"

	//TODO: Move all of this stuff into the various pipe constructors.
	var/obj/machinery/atmospherics/P = new constructed_path(get_turf(src))

	P.pipe_color = color
	if (P.colorable)
		P.color = color
	P.set_dir(dir)
	P.set_initial_level()

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

/obj/item/pipe/injector
	name = "Injector"
	desc = "Passively injects air into its surroundings. Has a valve attached to it that can control flow rate."
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
	connect_types = I.connect_types

/obj/item/machine_chassis
	var/build_type

/obj/item/machine_chassis/attackby(var/obj/item/W, var/mob/user)
	if(!isWrench(W))
		return ..()
	var/obj/machinery/machine = new build_type(get_turf(src), dir, FALSE)
	machine.apply_component_presets()
	machine.RefreshParts()
	if(machine.construct_state)
		machine.construct_state.post_construct(machine)
	playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You have fastened the [src].</span>")
	qdel(src)

/obj/item/machine_chassis/air_sensor
	name = "gas sensor"
	desc = "A sensor. It detects gasses."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	w_class = ITEM_SIZE_LARGE
	build_type = /obj/machinery/air_sensor

/obj/item/machine_chassis/pipe_meter
	name = "meter"
	desc = "A meter that can measure gas inside pipes or in the general area."
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = ITEM_SIZE_LARGE
	build_type = /obj/machinery/meter