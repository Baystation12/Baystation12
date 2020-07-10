
/atom/proc/change_elevation(var/amount = 1)
	var/new_alpha = alpha - (50 * amount)
	animate(src,alpha = new_alpha,time = amount SECONDS)
	elevation += amount

/atom/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	return (!density || (mover && mover.elevation != elevation) || !height || air_group)

/atom/movable/Cross(var/atom/movable/crosser)
	if(crosser.elevation != elevation)
		return 1
	. = ..()
