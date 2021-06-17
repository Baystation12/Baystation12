/atom/proc/disrupts_psionics()
	for(var/thing in contents)
		var/atom/movable/AM = thing
		var/disrupted_by = AM.disrupts_psionics()
		if(disrupted_by)
			return disrupted_by
	return FALSE

/atom/proc/do_psionics_check(var/stress, var/atom/source)
	var/turf/T = get_turf(src)
	if(istype(T) && T != src)
		return T.do_psionics_check(stress, source)
	withstand_psi_stress(stress, source)
	. = disrupts_psionics()

/atom/proc/withstand_psi_stress(var/stress, var/atom/source)
	. = max(stress, 0)
	if(.)
		for(var/thing in contents)
			var/atom/movable/AM = thing
			if(istype(AM) && AM != src && AM.disrupts_psionics())
				. = AM.withstand_psi_stress(., source)
				if(. <= 0)
					break
