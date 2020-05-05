#define FINISH_UNKNOWN 0
#define FINISH_DESTROYED 1
#define FINISH_LEFT 2
#define FINISH_OVERRUN 3

/datum/game_mode/firefight/proc/survivors_left()
	. = FALSE
	for(var/mob/living/M in GLOB.player_list)
		if(M.client && M.stat == CONSCIOUS && M.faction == src.player_faction_name)
			return TRUE

/datum/game_mode/firefight/check_finished()

	if(world.time < safe_time)
		return ..()

	//check if the evac ship was destroyed
	if(evac_stage > 1)
		var/obj/structure/evac_ship/evac_ship = locate() in world
		if(!evac_ship || evac_ship.health <= 0)
			finish_reason = 1
			return 1

		//evac has left! the round is over
		if(world.time > time_evac_leave)
			finish_reason = 2
			return 1

	//if the players are all dead
	if(!survivors_left())
		finish_reason = 3
		return 1

	//don't finish if there are still enemies left
	/*
	if(overmind.combat_troops.len)
		return ..()
		*/

	//this is to do generic checks such as round end vote
	return ..()

/datum/game_mode/firefight/declare_completion()

	var/announcement_text = stuck_message
	switch(finish_reason)
		if(FINISH_DESTROYED)
			announcement_text = destroyed_message

		if(FINISH_LEFT)
			announcement_text = win_message
			var/no_survivors = 1
			for(var/mob/living/M in GLOB.player_list)
				if(M.stat != DEAD && M.loc == evac_ship)
					announcement_text += "<span class='emote'><span class='prefix'>[M]</span>, [M.job]</span> (played by <span class='info'>[M.ckey]</span>)<br>"
					no_survivors = 0
			if(no_survivors)
				announcement_text = empty_message

		if(FINISH_OVERRUN)
			announcement_text = overrun_message

	to_world(announcement_text)

#undef FINISH_UNKNOWN
#undef FINISH_DESTROYED
#undef FINISH_LEFT
#undef FINISH_OVERRUN
