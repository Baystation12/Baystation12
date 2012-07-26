/zone
	proc/AddTurf(turf/T)
		//Adds the turf to contents, increases the size of the zone, and sets the zone var.
		if(T in contents)
			return
		if(T.zone)
			T.zone.RemoveTurf(T)
		contents += T
		if(air)
			air.group_multiplier++
		T.zone = src
	proc/RemoveTurf(turf/T)
		//Same, but in reverse.
		if(!(T in contents))
			return
		contents -= T
		if(air)
			air.group_multiplier--
		T.zone = null

	proc/AddSpace(turf/space/S)
		//Adds a space tile to the list, and creates the list if null.
		if(istype(S))
			if(!space_tiles)
				space_tiles = list()
			else if(S in space_tiles)
				return
			space_tiles += S
			contents -= S

	proc/RemoveSpace(turf/space/S)
		//Removes a space tile from the list, and deletes the list if length is 0.
		if(space_tiles)
			space_tiles -= S
			if(!space_tiles.len) space_tiles = null

/turf/proc/HasDoor(turf/O)
	//Checks for the presence of doors, used for zone spreading and connection.
	//A positive numerical argument checks only for closed doors.
	//Another turf as an argument checks for windoors between here and there.
	for(var/obj/machinery/door/D in src)
		if(isnum(O) && O)
			if(!D.density) continue
		if(istype(D,/obj/machinery/door/window))
			if(!O) continue
			if(D.dir == get_dir(D,O)) return 1
		else
			return 1

/turf/proc/check_connections()
	//Checks for new connections that can be made.
	for(var/d in cardinal)
		var/turf/simulated/T = get_step(src,d)
		if(!istype(T) || !T.zone || !T.CanPass(0,src,0,0))
			continue
		if(T.zone != zone)
			ZConnect(src,T)

/turf/proc/check_for_space()
	//Checks for space around the turf.
	for(var/d in cardinal)
		var/turf/T = get_step(src,d)
		if(istype(T,/turf/space) && T.CanPass(0,src,0,0))
			zone.AddSpace(T)

proc/ZMerge(zone/A,zone/B)
	//Merges two zones so that they are one.
	var
		a_size = A.air.group_multiplier
		b_size = B.air.group_multiplier
		c_size = a_size + b_size
		new_contents = A.contents + B.contents

	//Set air multipliers to one so air represents gas per tile.
	A.air.group_multiplier = 1
	B.air.group_multiplier = 1

	//Remove some air proportional to the size of this zone.
	A.air.remove_ratio(a_size/c_size)
	B.air.remove_ratio(b_size/c_size)

	//Merge the gases and set the multiplier to the sum of the old ones.
	A.air.merge(B.air)
	A.air.group_multiplier = c_size

	//Check for connections to merge into the new zone.
	for(var/connection/C in B.connections)
		if((C.A in new_contents) && (C.B in new_contents))
			del C
			continue
		if(!A.connections) A.connections = list()
		A.connections += C

	//Add space tiles.
	A.space_tiles += B.space_tiles

	//Add contents.
	A.contents = new_contents

	//Set all the zone vars.
	for(var/turf/simulated/T in B.contents)
		T.zone = A

	for(var/connection/C in A.connections)
		C.Cleanup()

	del B

proc/ZConnect(turf/simulated/A,turf/simulated/B)
	//Connects two zones by forming a connection object representing turfs A and B.

	//Make sure that if it's space, it gets added to space_tiles instead.
	if(istype(B,/turf/space))
		if(A.zone)
			A.zone.AddSpace(B)
		return
	if(istype(A,/turf/space))
		if(B.zone)
			B.zone.AddSpace(A)
		return

	if(!istype(A) || !istype(B))
		return

	//Make some preliminary checks to see if the connection is valid.
	if(!A.zone || !B.zone) return
	if(A.zone == B.zone) return
	if(!A.CanPass(null,B,0,0)) return
	if(A.CanPass(null,B,1.5,1))
		return ZMerge(A.zone,B.zone)

	//Ensure the connection isn't already made.
	if("\ref[A]" in air_master.turfs_with_connections)
		for(var/connection/C in air_master.turfs_with_connections["\ref[A]"])
			C.Cleanup()
			if(C && (C.B == B || C.A == B))
				return

	new /connection(A,B)

/*
proc/ZDisconnect(turf/A,turf/B)
	//Removes a zone connection. Can split zones in the case of a permanent barrier.

	//If one of them doesn't have a zone, it might be space, so check for that.
	if(A.zone && B.zone)
		//If the two zones are different, just remove a connection.
		if(A.zone != B.zone)
			for(var/connection/C in A.zone.connections)
				if((C.A == A && C.B == B) || (C.A == B && C.B == A))
					del C
				if(C)
					C.Cleanup()
		//If they're the same, split the zone at this line.
		else
			//Preliminary checks to prevent stupidity.
			if(A == B) return
			if(A.CanPass(0,B,0,0)) return
			if(A.HasDoor(B) || B.HasDoor(A)) return

			//Do a test fill. If turf B is still in the floodfill, then the zone isn't really split.
			var/zone/oldzone = A.zone
			var/list/test = FloodFill(A)
			if(B in test) return

			else
				var/zone/Z = new(test,oldzone.air) //Create a new zone based on the old air and the test fill.

				//Add connections from the old zone.
				for(var/connection/C in oldzone.connections)
					if((C.A in Z.contents) || (C.B in Z.contents))
						if(!Z.connections) Z.connections = list()
						Z.connections += C
						C.Cleanup()

				//Check for space.
				for(var/turf/T in test)
					T.check_for_space()

				//Make a new, identical air mixture for the other zone.
				var/datum/gas_mixture/Y_Air = new
				Y_Air.copy_from(oldzone.air)

				var/zone/Y = new(B,Y_Air) //Make a new zone starting at B and using Y_Air.

				//Add relevant connections from old zone.
				for(var/connection/C in oldzone.connections)
					if((C.A in Y.contents) || (C.B in Y.contents))
						if(!Y.connections) Y.connections = list()
						Y.connections += C
						C.Cleanup()

				//Add the remaining space tiles to this zone.
				for(var/turf/space/T in oldzone.space_tiles)
					if(!(T in Z.space_tiles))
						Y.AddSpace(T)

				oldzone.air = null
				del oldzone
	else
		if(B.zone)
			if(istype(A,/turf/space))
				B.zone.RemoveSpace(A)
			else
				for(var/connection/C in B.zone.connections)
					if((C.A == A && C.B == B) || (C.A == B && C.B == A))
						del C
					if(C)
						C.Cleanup()
		if(A.zone)
			if(istype(B,/turf/space))
				A.zone.RemoveSpace(B)
			else
				for(var/connection/C in A.zone.connections)
					if((C.A == A && C.B == B) || (C.A == B && C.B == A))
						del C
					if(C)
						C.Cleanup()*/