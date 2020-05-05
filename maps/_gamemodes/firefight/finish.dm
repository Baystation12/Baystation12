
/datum/game_mode/firefight/proc/survivors_left()
	. = FALSE
	for(var/mob/living/M in GLOB.player_list)
		if(M.client && M.stat == CONSCIOUS && M.faction == src.player_faction)
			return TRUE

/datum/game_mode/firefight/check_finished()

	if(world.time < safe_time)
		return ..()

	//check if the evac ship was destroyed
	if(evac_stage > 1)
		var/obj/structure/evac_ship/evac_ship = locate() in world
		if(!evac_ship || evac_ship.health <= 0)
			return 1

		//evac has left! the round is over
		if(world.time > time_evac_leave)
			return 1

	//if the players are all dead
	if(!survivors_left())
		return 1

	//don't finish if there are still enemies left
	if(overmind.combat_troops.len)
		return ..()

	//this is to do generic checks such as round end vote
	return ..()

/datum/game_mode/firefight/declare_completion()

	var/announcement_text = stuck_message
	if(!player_faction.players_alive())
		announcement_text = overrun_message
	else if(evac_stage)
		var/obj/structure/evac_ship/evac_ship = locate() in world
		if(evac_ship && evac_ship.health <= 0)
			evac_ship = null
		if(evac_ship)
			announcement_text = win_message
			var/no_survivors = 1
			for(var/mob/living/M in GLOB.player_list)
				if(M.stat != DEAD && M.loc == evac_ship)
					announcement_text += "<span class='emote'><span class='prefix'>[M]</span>, [M.job]</span> (played by <span class='info'>[M.ckey]</span>)<br>"
					no_survivors = 0
			if(no_survivors)
				announcement_text = empty_message
		else
			announcement_text = destroyed_message

	to_world(announcement_text)
