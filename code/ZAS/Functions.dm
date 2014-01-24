//Global Functions
//Contents: FloodFill, ZMerge, ZConnect

//Floods outward from an initial turf to fill everywhere it's zone would reach.
proc/FloodFill(turf/simulated/start)

	if(!istype(start))
		return list()

	//The list of tiles waiting to be evaulated.
	var/list/open = list(start)
	//The list of tiles which have been evaulated.
	var/list/closed = list()
/////// Z-Level stuff
	//List of all space tiles bordering the zone
	var/list/list_space = list()
	//List of all Z-Levels of the zone where it borders space
	var/list/z_space = list()
/////// Z-Level stuff

	//Loop through the turfs in the open list in order to find which adjacent turfs should be added to the zone.
	while(open.len)
		var/turf/simulated/T = pick(open)

		//sanity!
		if(!istype(T))
			open -= T
			continue

		//Check all cardinal directions
		for(var/d in cardinal)
			var/turf/simulated/O = get_step(T,d)

			//Ensure the turf is of proper type, that it is not in either list, and that air can reach it.
			if(istype(O) && !(O in open) && !(O in closed) && O.ZCanPass(T))

				//Handle connections from a tile with a door.
				if(T.HasDoor())
					//If they both have doors, then they are not able to connect period.
					if(O.HasDoor())
						continue

					//Connect first to north and west
					if(d == NORTH || d == WEST)
						open += O

					//If that fails, and north/west cannot be connected to, see if west or south can be connected instead.
					else
						var/turf/simulated/W = get_step(O, WEST)
						var/turf/simulated/N = get_step(O, NORTH)

						if( !O.ZCanPass(N) && !O.ZCanPass(W) )
							//If it cannot connect either to the north or west, connect it!
							open += O

				//If no doors are involved, add it immediately.
				else if(!O.HasDoor())
					open += O

				//Handle connecting to a tile with a door.
				else
					if(d == SOUTH || d == EAST)
						//doors prefer connecting to zones to the north  or west
						closed += O

					else
						//see if we need to force an attempted connection
						//(there are no potentially viable zones to the north/west of the door)
						var/turf/simulated/W = get_step(O, WEST)
						var/turf/simulated/N = get_step(O, NORTH)

						if( !O.ZCanPass(N) && !O.ZCanPass(W) )
							//If it cannot connect either to the north or west, connect it!
							closed += O

/////// Z-Level stuff
			if(istype(O,/turf/space))
				if(!(O in list_space))
					list_space += O
					if(!(O.z in z_space))
						z_space += O.z

		// handle Z-level connections
		var/turf/controllerlocation = locate(1, 1, T.z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			// connect upwards
			if(controller.up)
				var/turf/above_me = locate(T.x, T.y, controller.up_target)
				// add the turf above this
				if(istype(above_me, /turf/simulated/floor/open) && !(above_me in open) && !(above_me in closed))
					open += above_me

				if(istype(above_me,/turf/space))
					if(!(above_me in list_space))
						list_space += above_me
						if(!(above_me.z in z_space))
							z_space += above_me.z
			// connect downwards
			if(controller.down && istype(T, /turf/simulated/floor/open))
				var/turf/below_me = locate(T.x, T.y, controller.down_target)
				// add the turf below this
				if(!(below_me in open) && !(below_me in closed))
					open += below_me
/////// Z-Level stuff

		//This tile is now evaluated, and can be moved to the list of evaluated tiles.
		open -= T
		closed += T

/////// Z-Level stuff
		// once the zone is done, check if there is space that needs to be changed to open space
		if(!open.len)
			var/list/temp = list()
			while(list_space.len)
				var/turf/S = pick(list_space)
				//check if the zone has any space borders below the evaluated space tile
				//if there is some, we dont need to make open_space since the zone can vent and the zone above can vent
				//through the evaluated tile
				//if there is none, the zone can connect upwards to either vent from there or connect with the zone there
				//also check if the turf below the space is actually part of this zone to prevent the edge tiles from transforming
				var/turf/controllerloc = locate(1, 1, S.z)
				for(var/obj/effect/landmark/zcontroller/controller in controllerloc)
					if(controller.down)
						var/turf/below = locate(S.x, S.y, controller.down_target)
						if(!((S.z - 1) in z_space) && below in closed)
							open += S.ChangeTurf(/turf/simulated/floor/open)
							list_space -= S
						else
							list_space -= S
							temp += S
					else
						list_space -= S
						temp += S
				// make sure the turf is removed from the list
				list_space -= S
			z_space -= z_space
			while(temp.len)
				var/turf/S = pick(temp)
				if(!(S.z in z_space))
					z_space += S.z
				list_space += S
				temp -= S
/////// Z-Level stuff

	return closed


//Procedure to merge two zones together.
proc/ZMerge(zone/A,zone/B)

	//Sanity~
	if(!istype(A) || !istype(B))
		return

	var/new_contents = A.contents + B.contents

	//Set all the zone vars.
	for(var/turf/simulated/T in B.contents)
		T.zone = A

	if(istype(A.air) && istype(B.air))
		//Merges two zones so that they are one.
		var/a_size = A.air.group_multiplier
		var/b_size = B.air.group_multiplier
		var/c_size = a_size + b_size

		//Set air multipliers to one so air represents gas per tile.
		A.air.group_multiplier = 1
		B.air.group_multiplier = 1

		//Remove some air proportional to the size of this zone.
		A.air.remove_ratio(a_size/c_size)
		B.air.remove_ratio(b_size/c_size)

		//Merge the gases and set the multiplier to the sum of the old ones.
		A.air.merge(B.air)
		A.air.group_multiplier = c_size

	//I hate when the air datum somehow disappears.
	//  Try to make it sorta work anyways.  Fakit
	else if(istype(B.air))
		A.air = B.air
		A.air.group_multiplier = A.contents.len

	else if(istype(A.air))
		A.air.group_multiplier = A.contents.len

	//Doublefakit.
	else
		A.air = new

	//Check for connections to merge into the new zone.
	for(var/connection/C in B.connections)
		//The Cleanup proc will delete the connection if the zones are the same.
		//	It will also set the zone variables correctly.
		C.Cleanup()

	//Add space tiles.
	if(A.unsimulated_tiles && B.unsimulated_tiles)
		A.unsimulated_tiles |= B.unsimulated_tiles
	else if (B.unsimulated_tiles)
		A.unsimulated_tiles = B.unsimulated_tiles

	//Add contents.
	A.contents = new_contents

	//Remove the "B" zone, finally.
	B.SoftDelete()


//Connects two zones by forming a connection object representing turfs A and B.
proc/ZConnect(turf/simulated/A,turf/simulated/B)

	//Make sure that if it's space, it gets added to unsimulated_tiles instead.
	if(!istype(B))
		if(A.zone)
			A.zone.AddTurf(B)
		return
	if(!istype(A))
		if(B.zone)
			B.zone.AddTurf(A)
		return

	if(!istype(A) || !istype(B))
		return

	//Make some preliminary checks to see if the connection is valid.
	if(!A.zone || !B.zone) return
	if(A.zone == B.zone)
		air_master.AddIntrazoneConnection(A,B)
		return

	if(A.CanPass(null, B, 1.5, 1) && A.zone.air.compare(B.zone.air))
		return ZMerge(A.zone,B.zone)

	//Ensure the connection isn't already made.
	if(A in air_master.turfs_with_connections)
		for(var/connection/C in air_master.turfs_with_connections[A])
			if(C.B == B || C.A == B)
				return

	//Make the connection.
	new /connection(A,B)
