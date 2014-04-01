atom/movable/proc/setloc(newloc)
	if(light)
		var/oldloc = loc
		loc = newloc
		if(isturf(newloc) != isturf(oldloc)) light.Reset()
	else
		loc = newloc
