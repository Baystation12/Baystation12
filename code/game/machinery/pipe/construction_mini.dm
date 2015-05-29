/*CONTENTS
Buildable pipes
Buildable meters
*/
#define PIPE_SIMPLE_STRAIGHT	0
#define PIPE_SIMPLE_BENT		1
#define PIPE_HE_STRAIGHT		2
#define PIPE_HE_BENT			3
#define PIPE_CONNECTOR			4
#define PIPE_MANIFOLD			5
#define PIPE_JUNCTION			6
#define PIPE_UVENT				7
#define PIPE_MVALVE				8
#define PIPE_PUMP				9
#define PIPE_SCRUBBER			10
#define PIPE_INSULATED_STRAIGHT	11
#define PIPE_INSULATED_BENT		12
#define PIPE_GAS_FILTER			13
#define PIPE_GAS_MIXER			14
#define PIPE_PASSIVE_GATE       15
#define PIPE_VOLUME_PUMP        16
#define PIPE_HEAT_EXCHANGE      17
#define PIPE_MTVALVE			18
#define PIPE_MANIFOLD4W			19
#define PIPE_CAP				20
///// Z-Level stuff
#define PIPE_UP					21
#define PIPE_DOWN				22
///// Z-Level stuff
#define PIPE_GAS_FILTER_M		23
#define PIPE_GAS_MIXER_T		24
#define PIPE_GAS_MIXER_M		25
#define PIPE_OMNI_MIXER			26
#define PIPE_OMNI_FILTER		27
///// Supply, scrubbers and universal pipes
#define PIPE_UNIVERSAL				28
#define PIPE_SUPPLY_STRAIGHT		29
#define PIPE_SUPPLY_BENT			30
#define PIPE_SCRUBBERS_STRAIGHT		31
#define PIPE_SCRUBBERS_BENT			32
#define PIPE_SUPPLY_MANIFOLD		33
#define PIPE_SCRUBBERS_MANIFOLD		34
#define PIPE_SUPPLY_MANIFOLD4W		35
#define PIPE_SCRUBBERS_MANIFOLD4W	36
#define PIPE_SUPPLY_UP				37
#define PIPE_SCRUBBERS_UP			38
#define PIPE_SUPPLY_DOWN			39
#define PIPE_SCRUBBERS_DOWN			40
#define PIPE_SUPPLY_CAP				41
#define PIPE_SCRUBBERS_CAP			42

#define PIPE_DVALVE					43
#define PIPE_MTVALVE_M				44
#define PIPE_DTVALVE				45
#define PIPE_INJECTOR				47
#define PIPE_DP_VENT				48

/obj/item/pipe
	name = "pipe"
	desc = "A pipe"
	var/pipe_type = 0
	var/pipename
	var/matrix/M = new() //For rotate()
	force = 7
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = ""
	w_class = 3
	level = 2

	var/connect_types = CONNECT_TYPE_REGULAR
	var/list/obj/machinery/atmospherics/nodes = new()

/obj/item/pipe/ex_act(severity)
	switch(severity)
		if(1)
			PlaceInPool(src)
		if(2)
			if(prob(40))
				PlaceInPool(src)
		if(3)
			if(prob(10))
				PlaceInPool(src)

/obj/item/pipe/blob_act()
	PlaceInPool(src)

/obj/item/pipe/singularity_act()
	PlaceInPool(src)
	return 2

/obj/item/pipe/New(var/loc, var/pipe_type as num, var/dir as num, var/obj/machinery/atmospherics/make_from = null)
	..()

	if (make_from)
		src.connect_types = make_from.connect_types
		src.nodes = make_from.nodes
		src.set_dir(make_from.dir)
		src.pipename = make_from.name
		src.name = make_from.name
		src.color = make_from.pipe_color
		src.pipe_type = make_from.type
		src.icon = getFlatIcon(make_from)
		src.pixel_x = rand(-5, 5)
		src.pixel_y = rand(-5, 5)
	else qdel(src)


//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/simulated/floor/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target))
		user.drop_from_inventory(src, target)
	else
		return ..()

// rotate the pipe item clockwise

/obj/item/pipe/verb/rotate()
	set category = "Object"
	set name = "Rotate Pipe"
	set src in view(1)

	if ( usr.stat || usr.restrained() )
		return

	src.set_dir(turn(src.dir, -90))

	M.Turn(90)
	src.transform = M

	return

/obj/item/pipe/Move()
	return ..()

// returns all pipe's endpoints

/obj/item/pipe/attack_self(mob/user as mob)
	return rotate()

/obj/item/pipe/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()
	//*
	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	if (!isturf(src.loc))
		return 1
/*
	for(var/obj/machinery/atmospherics/M in src.loc)
		if((M.initialize_directions & pipe_dir) && M.check_connect_types_construction(M,src))	// matches at least one direction on either type of pipe & same connection type
			user << "\red There is already a pipe of the same type at this location."
			return 1
	// no conflicts found
*/
	var/obj/machinery/atmospherics/P

	if(ispath(pipe_type))
		P=new pipe_type(src.loc)

	if(P)

		P.color = color
		P.pipe_color = color
		P.set_dir(dir)
		if (pipename)
			P.name = pipename
		var/turf/T = loc
		P.level = T.intact ? 2 : 1

		if(P.initialize())

			playsound(get_turf(src), 'sound/items/Ratchet.ogg', 50, 1)
			user.visible_message( \
				"[user] fastens \the [src].", \
				"<span class='notice'>You have fastened \the [src].</span>", \
				"You hear a ratchet.")
			PlaceInPool(src)	// remove the pipe item

		return 0
	else
		// If the pipe's still around, nuke it.
	//	if(P)
	//		qdel(P)
		error("[src]'s buildFrom does not return 1!")
		qdel(P)
	return 1
	 //TODO: DEFERRED

// ensure that setterm() is called for a newly connected pipeline



/obj/item/pipe_meter
	name = "meter"
	desc = "A meter that can be laid on pipes"
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = 4

/obj/item/pipe_meter/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()

	if (istype(W, /obj/item/weapon/screwdriver))
		var/turf/T = get_turf(src)
		new/obj/machinery/meter/turf( T )
		user << "\blue You have fastened the meter to the [T]"
		qdel(src)

	if (!istype(W, /obj/item/weapon/wrench))
		return ..()
	if(!locate(/obj/machinery/atmospherics/pipe, src.loc))
		user << "\red You need to fasten it to a pipe"
		return 1
	new/obj/machinery/meter( src.loc )
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user << "\blue You have fastened the meter to the pipe"
	qdel(src)

#undef PIPE_SIMPLE_STRAIGHT
#undef PIPE_SIMPLE_BENT
#undef PIPE_HE_STRAIGHT
#undef PIPE_HE_BENT
#undef PIPE_CONNECTOR
#undef PIPE_MANIFOLD
#undef PIPE_JUNCTION
#undef PIPE_UVENT
#undef PIPE_MVALVE
#undef PIPE_PUMP
#undef PIPE_SCRUBBER
#undef PIPE_INSULATED_STRAIGHT
#undef PIPE_INSULATED_BENT
#undef PIPE_GAS_FILTER
#undef PIPE_GAS_MIXER
#undef PIPE_PASSIVE_GATE
#undef PIPE_VOLUME_PUMP
#undef PIPE_HEAT_EXCHANGE
#undef PIPE_MTVALVE
#undef PIPE_MANIFOLD4W
#undef PIPE_CAP
#undef PIPE_UP
#undef PIPE_DOWN
#undef PIPE_GAS_FILTER_M
#undef PIPE_GAS_MIXER_T
#undef PIPE_GAS_MIXER_M
#undef PIPE_OMNI_MIXER
#undef PIPE_OMNI_FILTER
#undef PIPE_UNIVERSAL
#undef PIPE_SUPPLY_STRAIGHT
#undef PIPE_SUPPLY_BENT
#undef PIPE_SCRUBBERS_STRAIGHT
#undef PIPE_SCRUBBERS_BENT
#undef PIPE_SUPPLY_MANIFOLD
#undef PIPE_SCRUBBERS_MANIFOLD
#undef PIPE_SUPPLY_MANIFOLD4W
#undef PIPE_SCRUBBERS_MANIFOLD4W
#undef PIPE_SUPPLY_UP
#undef PIPE_SCRUBBERS_UP
#undef PIPE_SUPPLY_DOWN
#undef PIPE_SCRUBBERS_DOWN
#undef PIPE_SUPPLY_CAP
#undef PIPE_SCRUBBERS_CAP
#undef PIPE_DVALVE
#undef PIPE_MTVALVE_M
#undef PIPE_DTVALVE
#undef PIPE_INJECTOR
#undef PIPE_DP_VENT