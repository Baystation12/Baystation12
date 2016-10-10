/proc/mobs_in_range(var/atom/movable/AM)
	. = list()
	for(var/mob/observer/virtual/v_mob in range(world.view, get_turf(AM)))
		if(ismob(v_mob.host))
			. += v_mob.host

/proc/clients_in_range(var/atom/movable/AM)
	. = list()
	for(var/mob/observer/virtual/v_mob in range(world.view, get_turf(AM)))
		if(ismob(v_mob.host))
			var/mob/M = v_mob.host
			if(M.client)
				. |= M.client
