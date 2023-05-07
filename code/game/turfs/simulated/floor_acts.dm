/turf/simulated/floor/ex_act(severity)
	//set src in oview(1)
	switch(severity)
		if(EX_ACT_DEVASTATING)
			src.ChangeTurf(get_base_turf_by_area(src))
		if(EX_ACT_HEAVY)
			switch(pick(40;1,40;2,3))
				if (1)
					if(prob(33)) new /obj/item/stack/material/steel(src)
					src.ReplaceWithLattice()
				if(2)
					src.ChangeTurf(get_base_turf_by_area(src))
				if(3)
					if(prob(33)) new /obj/item/stack/material/steel(src)
					if(prob(80))
						src.break_tile_to_plating()
					else
						src.break_tile()
					src.hotspot_expose(1000,CELL_VOLUME)
		if(EX_ACT_LIGHT)
			if (prob(50))
				src.break_tile()
				src.hotspot_expose(1000,CELL_VOLUME)
	return

/turf/simulated/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	var/temp_destroy = get_damage_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		make_plating() //destroy the tile, exposing plating
		burn_tile(exposed_temperature)
	return

//should be a little bit lower than the temperature required to destroy the material
/turf/simulated/floor/proc/get_damage_temperature()
	return flooring ? flooring.damage_temperature : null

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	// Check for and affect things in a certain order to accomodate atoms that should cover and protect other atoms, such as fire doors
	// First, to avoid multiple type checked loops through source, build lists of the specific types of atoms
	var/list/fire_doors = list()
	var/list/other_doors = list()
	var/list/blocking_windows = list()

	var/list/blocking_atoms = list() // These atoms protect everything else on the turf from the fire
	var/list/other_atoms = list() // These atoms do not protect anything else

	for (var/atom/movable/A as anything in src)
		var/canpass
		switch (A.atmos_canpass)
			if (CANPASS_ALWAYS)
				canpass = TRUE
			if (CANPASS_DENSITY)
				canpass = !density
			if (CANPASS_PROC)
				canpass = !A.c_airblock(adj_turf)
			if (CANPASS_NEVER)
				canpass = FALSE
		if (canpass)
			continue

		if (istype(A, /obj/machinery/door))
			var/obj/machinery/door/door = A
			if (istype(door, /obj/machinery/door/blast) || istype(door, /obj/machinery/door/firedoor))
				fire_doors += door
			else
				other_doors += door
			continue

		if (istype(A, /obj/structure/window))
			var/obj/structure/window/window = A
			if (window.dir == dir_to || window.is_fulltile()) //Same direction or diagonal (full tile)
				blocking_windows += window
			else
				other_atoms += window
			continue

		other_atoms += A

	// These checks prevent null entries from showing up due to merging empty lists
	if (length(fire_doors))
		blocking_atoms |= fire_doors
	if (length(other_doors))
		blocking_atoms |= other_doors
	if (length(blocking_windows))
		blocking_atoms |= blocking_windows

	// Blocking - Hit the first one then stop.
	if (length(blocking_atoms))
		var/atom/A = blocking_atoms[1]
		A.fire_act(adj_air, adj_temp, adj_volume)
		return

	// Non-blocking - Hit everything
	for (var/atom/A as anything in other_atoms)
		A.fire_act(adj_air, adj_temp, adj_volume)
