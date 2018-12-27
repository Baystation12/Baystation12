
/datum/game_mode/packwar/process()
	if(ticker.current_state == GAME_STATE_PLAYING && world.time > time_next_mercenary_ship)
		time_next_mercenary_ship = world.time + rand(mercenary_interval_lower, mercenary_interval_upper)
		refresh_mercenaries()