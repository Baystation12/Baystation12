
/datum/game_mode/stranded/handle_mob_death(var/mob/M, var/list/args = list())
	all_survivors_dead = 1

	//look for any remaining living players
	for(var/mob/living/L in GLOB.player_list)
		if(L.stat == CONSCIOUS && L.client)
			all_survivors_dead = 0
			break
	return 1

/datum/game_mode/stranded/check_finished()
	if(world.time > time_pelican_leave)
		return 1
	if(all_survivors_dead)
		return 1
	if(world.time > time_pelican_arrive)
		var/obj/structure/evac_pelican/evac_pelican = locate() in world
		if(!evac_pelican || evac_pelican.health <= 0)
			return 1
	return 0

/datum/game_mode/stranded/declare_completion()

	var/obj/structure/evac_pelican/evac_pelican = locate() in world
	if(evac_pelican.health <= 0)
		evac_pelican = null
	var/announcement_text = ""
	if(evac_pelican)
		announcement_text = "<span class='good'>The pelican takes off! The survivors were:</span><br>"
		var/no_survivors = 1
		for(var/mob/living/M in GLOB.player_list)
			if(M.stat != DEAD && M.loc == evac_pelican)
				announcement_text += "<span class='emote'><span class='prefix'>[M]</span>, [M.job]</span> (played by <span class='info'>[M.ckey]</span>)<br>"
				no_survivors = 0
		if(no_survivors)
			announcement_text = "<span class='bad'>Defeat: No living survivors managed to evacuate on the pelican.</span>"
	else if(world.time > time_pelican_leave)
		announcement_text = "<span class='bad'>Defeat: The pelican has been destroyed! Any survivors are doomed to die alone in the wastes...</span><br>"
	else if(all_survivors_dead)
		announcement_text = "<span class='bad'>Defeat: The survivors have been overrun. The pelican did not arrive in time.</span>"

	to_world(announcement_text)
