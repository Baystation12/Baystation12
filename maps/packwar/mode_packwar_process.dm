
/datum/game_mode/packwar/process()
	if(world.time > time_next_mercenary_ship)
		time_next_mercenary_ship = world.time + rand(mercenary_interval_lower, mercenary_interval_upper)
		refresh_mercenaries()