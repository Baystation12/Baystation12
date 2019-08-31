// Updates whatever openspace components may be mimicing us. On turfs this queues an openturf update on the above openturf, on movables this updates their bound movable (if present). Meaningless on any type other than `/turf` or `/atom/movable` (incl. children).
/atom/proc/update_above()
	return

/turf/proc/is_above_space()
	var/turf/T = GetBelow(src)
	while (T && (T.z_flags & ZM_MIMIC_BELOW))
		T = GetBelow(T)

	return istype(T, /turf/space)

/turf/update_icon()
	..()
	if (above)
		update_above()

/atom/movable/update_icon()
	..()
	UPDATE_OO_IF_PRESENT
