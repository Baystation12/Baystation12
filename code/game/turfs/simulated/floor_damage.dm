/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/proc/break_tile()
	if(!flooring || !(flooring.flags & TURF_CAN_BREAK) || !isnull(broken))
		return
	if(flooring.has_damage_range)
		broken = rand(0,flooring.has_damage_range)
	else
		broken = 0
	update_icon()

/turf/simulated/floor/proc/burn_tile(var/exposed_temperature)
	if(!flooring || !(flooring.flags & TURF_CAN_BURN) || !isnull(burnt))
		return
	if(flooring.has_burn_range)
		burnt = rand(0,flooring.has_burn_range)
	else
		burnt = 0
	update_icon()