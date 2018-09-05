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

/obj/item/pipe/New(var/loc, var/obj/machinery/atmospherics/pipe/P)
	..()
	if(!P)
		return
	src.set_dir(P.dir)
	src.name = P.name
	src.desc = P.desc
	if(P.dir != NORTH|SOUTH || P.dir != EAST|WEST) //If the pipe isn't north-south or east-west facing, it's bent. Change pipe type accordingly
		src.pipe_type = P.pipe_type + 1 		   //all bent pipes are sequentially next on the list.
	else
		src.pipe_type = P.pipe_type
	src.connect_types = P.connect_types
	src.color = P.pipe_color
	src.icon = P.build_icon
	src.icon_state = P.build_icon_state

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
	//src.pipe_set_dir(get_pipe_dir())
	return

/obj/item/pipe/AltClick()
	rotate()

/obj/item/pipe/Move()
	..()
	if ((pipe_type in list (PIPE_SIMPLE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT, PIPE_HE_BENT, PIPE_FUEL_BENT)) \
		&& (src.dir in GLOB.cardinal))
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
		if(	PIPE_SIMPLE_STRAIGHT, \
			PIPE_HE_STRAIGHT, \
			PIPE_JUNCTION ,\
			PIPE_PUMP ,\
			PIPE_VOLUME_PUMP ,\
			PIPE_PASSIVE_GATE ,\
			PIPE_MVALVE, \
			PIPE_DVALVE, \
			PIPE_SVALVE, \
			PIPE_SUPPLY_STRAIGHT, \
			PIPE_SCRUBBERS_STRAIGHT, \
			PIPE_UNIVERSAL, \
			PIPE_FUEL_STRAIGHT, \
		)
			return dir|flip
		if(PIPE_SIMPLE_BENT, PIPE_HE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT, PIPE_FUEL_BENT)
			return dir //dir|acw
		if(PIPE_CONNECTOR,PIPE_UVENT,PIPE_SCRUBBER,PIPE_HEAT_EXCHANGE)
			return dir
		if(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER, PIPE_FUEL_MANIFOLD4W)
			return dir|flip|cw|acw
		if(PIPE_MANIFOLD, PIPE_SUPPLY_MANIFOLD, PIPE_SCRUBBERS_MANIFOLD, PIPE_FUEL_MANIFOLD)
			return flip|cw|acw
		if(PIPE_MTVALVE)
			return dir|flip|cw
		if(PIPE_MTVALVEM)
			return dir|flip|acw
		if(PIPE_CAP, PIPE_SUPPLY_CAP, PIPE_SCRUBBERS_CAP, PIPE_FUEL_CAP)
			return dir
///// Z-Level stuff
		if(PIPE_UP,PIPE_DOWN,PIPE_SUPPLY_UP,PIPE_SUPPLY_DOWN,PIPE_SCRUBBERS_UP,PIPE_SCRUBBERS_DOWN,PIPE_FUEL_UP,PIPE_FUEL_DOWN)
			return dir
///// Z-Level stuff
	return 0

/obj/item/pipe/proc/get_pdir() //endpoints for regular pipes

	var/flip = turn(dir, 180)
//	var/cw = turn(dir, -90)
//	var/acw = turn(dir, 90)

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

//	var/flip = turn(dir, 180)
//	var/cw = turn(dir, -90)

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

/obj/item/pipe/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()
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
	switch(pipe_type)
		if(PIPE_SIMPLE_STRAIGHT, PIPE_SIMPLE_BENT)
			var/obj/machinery/atmospherics/pipe/simple/P = new( src.loc )
			P.pipe_color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			if (QDELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_SUPPLY_STRAIGHT, PIPE_SUPPLY_BENT)
			var/obj/machinery/atmospherics/pipe/simple/hidden/supply/P = new( src.loc )
			P.color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			if (QDELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_SCRUBBERS_STRAIGHT, PIPE_SCRUBBERS_BENT)
			var/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers/P = new( src.loc )
			P.color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			if (QDELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_FUEL_STRAIGHT, PIPE_FUEL_BENT)
			var/obj/machinery/atmospherics/pipe/simple/hidden/fuel/P = new( src.loc )
			P.color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			if (QDELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_UNIVERSAL)
			var/obj/machinery/atmospherics/pipe/simple/hidden/universal/P = new( src.loc )
			P.color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			if (QDELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_HE_STRAIGHT, PIPE_HE_BENT)
			var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/P = new ( src.loc )
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir //this var it's used to know if the pipe is bent or not
			P.initialize_directions_he = pipe_dir
			P.atmos_init()
			if (QDELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_CONNECTOR)		// connector
			var/obj/machinery/atmospherics/portables_connector/C = new( src.loc )
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			if (pipename)
				C.SetName(pipename)
			var/turf/T = C.loc
			C.level = !T.is_plating() ? 2 : 1
			C.atmos_init()
			C.build_network()
			if (C.node)
				C.node.atmos_init()
				C.node.build_network()


		if(PIPE_MANIFOLD)		//manifold
			var/obj/machinery/atmospherics/pipe/manifold/M = new( src.loc )
			M.pipe_color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (QDELETED(M))
				to_chat(usr, pipefailtext)
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()

		if(PIPE_SUPPLY_MANIFOLD)		//manifold
			var/obj/machinery/atmospherics/pipe/manifold/hidden/supply/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothing to connect this manifold to! (with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()

		if(PIPE_SCRUBBERS_MANIFOLD)		//manifold
			var/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothing to connect this manifold to! (with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()

		if(PIPE_FUEL_MANIFOLD)		//manifold
			var/obj/machinery/atmospherics/pipe/manifold/hidden/fuel/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothing to connect this manifold to! (with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()

		if(PIPE_MANIFOLD4W)		//4-way manifold
			var/obj/machinery/atmospherics/pipe/manifold4w/M = new( src.loc )
			M.pipe_color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (QDELETED(M))
				to_chat(usr, pipefailtext)
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()
			if (M.node4)
				M.node4.atmos_init()
				M.node4.build_network()

		if(PIPE_SUPPLY_MANIFOLD4W)		//4-way manifold
			var/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			M.connect_types = src.connect_types
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothing to connect this manifold to! (with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()
			if (M.node4)
				M.node4.atmos_init()
				M.node4.build_network()

		if(PIPE_SCRUBBERS_MANIFOLD4W)		//4-way manifold
			var/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			M.connect_types = src.connect_types
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothing to connect this manifold to! (with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()
			if (M.node4)
				M.node4.atmos_init()
				M.node4.build_network()

		if(PIPE_FUEL_MANIFOLD4W)		//4-way manifold
			var/obj/machinery/atmospherics/pipe/manifold4w/hidden/fuel/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			M.connect_types = src.connect_types
			//M.New()
			var/turf/T = M.loc
			M.level = !T.is_plating() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothing to connect this manifold to! (with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()
			if (M.node4)
				M.node4.atmos_init()
				M.node4.build_network()

		if(PIPE_JUNCTION)
			var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/P = new ( src.loc )
			P.set_dir(src.dir)
			P.initialize_directions = src.get_pdir() | src.get_hdir()
			P.initialize_directions_he = src.get_hdir()
			P.atmos_init()
			if (QDELETED(P))
				to_chat(usr, pipefailtext)//"There's nothing to connect this pipe to! (with how the pipe code works, at least one end needs to be connected to something, otherwise the game deletes the segment)"

				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_UVENT)		//unary vent
			var/obj/machinery/atmospherics/unary/vent_pump/V = new( src.loc )
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.SetName(pipename)
			var/turf/T = V.loc
			V.level = !T.is_plating() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node)
				V.node.atmos_init()
				V.node.build_network()


		if(PIPE_MVALVE)		//manual valve
			var/obj/machinery/atmospherics/valve/V = new( src.loc)
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.SetName(pipename)
			var/turf/T = V.loc
			V.level = !T.is_plating() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node1)
				V.node1.atmos_init()
				V.node1.build_network()
			if (V.node2)
				V.node2.atmos_init()
				V.node2.build_network()

		if(PIPE_DVALVE)		//digital valve
			var/obj/machinery/atmospherics/valve/digital/D = new( src.loc)
			D.set_dir(dir)
			D.initialize_directions = pipe_dir
			if (pipename)
				D.SetName(pipename)
			var/turf/T = D.loc
			D.level = !T.is_plating() ? 2 : 1
			D.atmos_init()
			D.build_network()
			if (D.node1)
				D.node1.atmos_init()
				D.node1.build_network()
			if (D.node2)
				D.node2.atmos_init()
				D.node2.build_network()

		if(PIPE_SVALVE)		//shutoff valve
			var/obj/machinery/atmospherics/valve/shutoff/S = new( src.loc)
			S.set_dir(dir)
			S.initialize_directions = pipe_dir
			if (pipename)
				S.SetName(pipename)
			var/turf/T = S.loc
			S.level = !T.is_plating() ? 2 : 1
			S.atmos_init()
			S.build_network()
			if (S.node1)
				S.node1.atmos_init()
				S.node1.build_network()
			if (S.node2)
				S.node2.atmos_init()
				S.node2.build_network()


		if(PIPE_PUMP)		//gas pump
			var/obj/machinery/atmospherics/binary/pump/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_SCRUBBER)		//scrubber
			var/obj/machinery/atmospherics/unary/vent_scrubber/S = new(src.loc)
			S.set_dir(dir)
			S.initialize_directions = pipe_dir
			if (pipename)
				S.SetName(pipename)
			var/turf/T = S.loc
			S.level = !T.is_plating() ? 2 : 1
			S.atmos_init()
			S.build_network()
			if (S.node)
				S.node.atmos_init()
				S.node.build_network()

		if(PIPE_MTVALVE)		//manual t-valve
			var/obj/machinery/atmospherics/tvalve/V = new(src.loc)
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.SetName(pipename)
			var/turf/T = V.loc
			V.level = !T.is_plating() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node1)
				V.node1.atmos_init()
				V.node1.build_network()
			if (V.node2)
				V.node2.atmos_init()
				V.node2.build_network()
			if (V.node3)
				V.node3.atmos_init()
				V.node3.build_network()

		if(PIPE_MTVALVEM)		//manual t-valve
			var/obj/machinery/atmospherics/tvalve/mirrored/V = new(src.loc)
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.SetName(pipename)
			var/turf/T = V.loc
			V.level = !T.is_plating() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node1)
				V.node1.atmos_init()
				V.node1.build_network()
			if (V.node2)
				V.node2.atmos_init()
				V.node2.build_network()
			if (V.node3)
				V.node3.atmos_init()
				V.node3.build_network()

		if(PIPE_CAP)
			var/obj/machinery/atmospherics/pipe/cap/C = new(src.loc)
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			C.atmos_init()
			C.build_network()
			if(C.node)
				C.node.atmos_init()
				C.node.build_network()

		if(PIPE_SUPPLY_CAP)
			var/obj/machinery/atmospherics/pipe/cap/hidden/supply/C = new(src.loc)
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			C.atmos_init()
			C.build_network()
			if(C.node)
				C.node.atmos_init()
				C.node.build_network()

		if(PIPE_SCRUBBERS_CAP)
			var/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers/C = new(src.loc)
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			C.atmos_init()
			C.build_network()
			if(C.node)
				C.node.atmos_init()
				C.node.build_network()

		if(PIPE_FUEL_CAP)
			var/obj/machinery/atmospherics/pipe/cap/hidden/fuel/C = new(src.loc)
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			C.atmos_init()
			C.build_network()
			if(C.node)
				C.node.atmos_init()
				C.node.build_network()

		if(PIPE_PASSIVE_GATE)		//passive gate
			var/obj/machinery/atmospherics/binary/passive_gate/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_VOLUME_PUMP)		//volume pump
			var/obj/machinery/atmospherics/binary/pump/high_power/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_HEAT_EXCHANGE)		// heat exchanger
			var/obj/machinery/atmospherics/unary/heat_exchanger/C = new( src.loc )
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			if (pipename)
				C.SetName(pipename)
			var/turf/T = C.loc
			C.level = !T.is_plating() ? 2 : 1
			C.atmos_init()
			C.build_network()
			if (C.node)
				C.node.atmos_init()
				C.node.build_network()
///// Z-Level stuff
		if(PIPE_UP)
			var/obj/machinery/atmospherics/pipe/zpipe/up/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_DOWN)
			var/obj/machinery/atmospherics/pipe/zpipe/down/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SUPPLY_UP)
			var/obj/machinery/atmospherics/pipe/zpipe/up/supply/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SUPPLY_DOWN)
			var/obj/machinery/atmospherics/pipe/zpipe/down/supply/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SCRUBBERS_UP)
			var/obj/machinery/atmospherics/pipe/zpipe/up/scrubbers/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SCRUBBERS_DOWN)
			var/obj/machinery/atmospherics/pipe/zpipe/down/scrubbers/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_FUEL_UP)
			var/obj/machinery/atmospherics/pipe/zpipe/up/fuel/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_FUEL_DOWN)
			var/obj/machinery/atmospherics/pipe/zpipe/down/fuel/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.SetName(pipename)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
///// Z-Level stuff
		if(PIPE_OMNI_MIXER)
			var/obj/machinery/atmospherics/omni/mixer/P = new(loc)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()
		if(PIPE_OMNI_FILTER)
			var/obj/machinery/atmospherics/omni/filter/P = new(loc)
			var/turf/T = P.loc
			P.level = !T.is_plating() ? 2 : 1
			P.atmos_init()
			P.build_network()

	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	user.visible_message( \
		"[user] fastens the [src].", \
		"<span class='notice'>You have fastened the [src].</span>", \
		"You hear ratchet.")
	qdel(src)	// remove the pipe item

	return
	 //TODO: DEFERRED

// ensure that setterm() is called for a newly connected pipeline



/obj/item/pipe_meter
	name = "meter"
	desc = "A meter that can be laid on pipes."
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = ITEM_SIZE_LARGE

/obj/item/pipe_meter/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()

	if(!isWrench(W))
		return ..()
	if(!locate(/obj/machinery/atmospherics/pipe, src.loc))
		to_chat(user, "<span class='warning'>You need to fasten it to a pipe</span>")
		return 1
	new/obj/machinery/meter( src.loc )
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You have fastened the meter to the pipe</span>")
	qdel(src)
