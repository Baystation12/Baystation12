/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/proc/break_tile()
	if(!isnull(broken))
		return
	if(flooring)
		if(!(flooring.flags & TURF_CAN_BREAK))
			return
		if(!flooring.has_damage_range)
			return
		broken = rand(0,flooring.has_damage_range)
	else
		broken = rand(0,4)
	remove_decals()
	update_icon()

/turf/simulated/floor/proc/burn_tile(var/exposed_temperature)
	if(!isnull(burnt))
		return
	if(flooring)
		if(!(flooring.flags & TURF_CAN_BURN))
			return
		if(!flooring.has_burn_range)
			return
		burnt = rand(0,flooring.has_burn_range)
	else
		burnt = rand(0,4)
	remove_decals()
	update_icon()