
/atom/CanPass(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	return (!density || (mover && mover.elevation != elevation) || !height || air_group)

/atom/movable/Cross(var/atom/movable/crosser)
	if(crosser.elevation != elevation)
		return 1
	. = ..()
