// For straight pipes
/proc/rotate_pipe_straight(var/newdir)
	switch(newdir)
		if(SOUTH)
			return NORTH
		if(WEST)
			return EAST
		if(NORTHWEST)
			return NORTH
		if(NORTHEAST)
			return EAST
		if(SOUTHWEST)
			return NORTH
		if(SOUTHEAST)
			return EAST
	return newdir
