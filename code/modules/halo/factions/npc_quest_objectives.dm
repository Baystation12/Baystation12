
/datum/objective/npc_quest
	var/num_respawns = 0
	var/respawn_interval = 1 SECONDS
	var/time_next_respawn = 0
	var/list/living_defenders = list()
	var/defender_check_index = 0
	var/defender_amount = 1
	var/list/dead_defenders = list()
	var/list/defender_types = list()
	var/list/spawn_turfs = list()

/datum/objective/npc_quest/proc/process()

	//scan over our living defenders to see if any have died
	defender_check_index++
	if(defender_check_index > living_defenders.len)
		defender_check_index = 1

	if(defender_check_index <= living_defenders.len)
		//grab the next mob to check
		var/mob/living/simple_animal/S = living_defenders

		//pathing check
		//

		//this one has been gibbed, so remove it's entry
		if(!S)
			living_defenders.Cut(defender_check_index, defender_check_index + 1)

		//see if it's dead/unconscious and we should respawn them
		else if(S.stat && num_respawns)

			//give it a single respawn
			S.limited_respawn = 1
			if(num_respawns > 0)
				num_respawns--

			//update the respawn timer
			if(time_next_respawn <= world.time)
				//make sure there are no instant respawns
				time_next_respawn = world.time
			time_next_respawn = time_next_respawn + respawn_interval
			S.respawn_timer = time_next_respawn

			//move it to the dead list
			living_defenders -= S
			dead_defenders += S

	//see if we need to manually respawn any defenders - because they have been gibbed or whatever
	if(living_defenders.len + dead_defenders.len < defender_amount)
		if(world.time >= time_next_respawn)
			//spawn a random new defender
			spawn_defender()
			time_next_respawn = world.time + respawn_interval

/datum/objective/npc_quest/proc/spawn_defender(var/defender_type = pickweight(defender_types))
	living_defenders += new defender_type(pick(spawn_turfs))

/datum/objective/npc_quest/kill

/datum/objective/npc_quest/kill/check_completion()
	. = 0
	if(living_defenders.len == 0)
		return 1

/datum/objective/npc_quest/assassinate
	var/mob/living/simple_animal/vip_mob

/datum/objective/npc_quest/assassinate/check_completion()
	. = 0
	if(!vip_mob)
		return 1

/datum/objective/npc_quest/steal

/datum/objective/npc_quest/sabotage
