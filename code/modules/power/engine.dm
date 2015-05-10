/turf/simulated/floor/engine/attack_hand(var/mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/simulated/floor/engine/ex_act(severity)
	switch(severity)
		if(0.0 to 1.0)
			ChangeTurf(/turf/space)
			qdel(src)
			return
		if(1.0 to 1.5)
			if (prob(20))
				ChangeTurf(/turf/space)
				qdel(src)
				return
		else
	return

/turf/simulated/floor/engine/blob_act()
	if (prob(25))
		ChangeTurf(/turf/space)
		qdel(src)
		return
	return