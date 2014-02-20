#define CONNECTION_DIRECT 2
#define CONNECTION_SPACE 4
#define CONNECTION_INVALID 8

/turf/simulated/var/tmp/connection_manager/connections = new


/connection_manager/var/connection/N
/connection_manager/var/connection/S
/connection_manager/var/connection/E
/connection_manager/var/connection/W

/connection_manager/proc/get(d)
	switch(d)
		if(NORTH)
			if(check(N)) return N
			else return null
		if(SOUTH)
			if(check(S)) return S
			else return null
		if(EAST)
			if(check(E)) return E
			else return null
		if(WEST)
			if(check(W)) return W
			else return null

/connection_manager/proc/place(connection/c, d)
	switch(d)
		if(NORTH) N = c
		if(SOUTH) S = c
		if(EAST) E = c
		if(WEST) W = c

/connection_manager/proc/update_all()
	if(check(N)) N.update()
	if(check(S)) S.update()
	if(check(E)) E.update()
	if(check(W)) W.update()

/connection_manager/proc/check(connection/c)
	return c && c.valid()


/connection/var/turf/simulated/A
/connection/var/turf/simulated/B
/connection/var/zone/zoneA
/connection/var/zone/zoneB

/connection/var/connection_edge/edge

/connection/var/state = 0

/connection/New(turf/simulated/A, turf/simulated/B)
	#ifdef ZASDBG
	ASSERT(air_master.has_valid_zone(A))
	//ASSERT(air_master.has_valid_zone(B))
	#endif
	src.A = A
	src.B = B
	zoneA = A.zone
	if(!istype(B))
		mark_space()
		edge = air_master.get_edge(A.zone,B)
		edge.add_connection(src)
	else
		zoneB = B.zone
		edge = air_master.get_edge(A.zone,B.zone)
		edge.add_connection(src)

/connection/proc/mark_direct()
	state |= CONNECTION_DIRECT

/connection/proc/mark_indirect()
	state &= ~CONNECTION_DIRECT

/connection/proc/mark_space()
	state |= CONNECTION_SPACE

/connection/proc/direct()
	return (state & CONNECTION_DIRECT)

/connection/proc/valid()
	return !(state & CONNECTION_INVALID)

/connection/proc/erase()
	edge.remove_connection(src)
	state |= CONNECTION_INVALID

/connection/proc/update()
	//world << "Updated, \..."
	if(!istype(A,/turf/simulated))
		//world << "Invalid A."
		erase()
		return

	if(air_master.air_blocked(A,B))
		//world << "Blocked connection."
		erase()
		return

	var/b_is_space = !istype(B,/turf/simulated)

	if(state & CONNECTION_SPACE)
		if(!b_is_space)
			//world << "Invalid B."
			erase()
			return
		if(A.zone != zoneA)
			//world << "Zone changed, \..."
			if(!A.zone)
				erase()
				//world << "erased."
				return
			else
				edge.remove_connection(src)
				edge = air_master.get_edge(A.zone, B)
				edge.add_connection(src)
				zoneA = A.zone

		//world << "valid."
		return

	else if(b_is_space)
		//world << "Invalid B."
		erase()
		return

	if(A.zone == B.zone)
		//world << "A == B"
		erase()
		return

	if(A.zone != zoneA || (zoneB && (B.zone != zoneB)))

		//world << "Zones changed, \..."
		if(A.zone && B.zone)
			edge.remove_connection(src)
			edge = air_master.get_edge(A.zone, B.zone)
			edge.add_connection(src)
			zoneA = A.zone
			zoneB = B.zone
		else
			//world << "erased."
			erase()
			return


	//world << "valid."