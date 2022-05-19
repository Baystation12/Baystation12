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

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
