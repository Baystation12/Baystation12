
/datum/npc_quest
	var/defender_check_index = 1
	var/num_respawns = 0
	var/respawn_interval = 4 SECONDS
	var/time_next_respawn = 0

/datum/npc_quest/proc/process()
	process_defenders()

/datum/npc_quest/proc/process_defenders()

	if(quest_status == STATUS_PROGRESS)

		//increment the index
		defender_check_index++
		if(defender_check_index > living_defenders.len)
			defender_check_index = 1

		//scan over our living defenders to see if any have died
		if(defender_check_index <= living_defenders.len)
			//grab the next mob to check
			var/mob/living/simple_animal/S = living_defenders[defender_check_index]

			//this one has been gibbed, so remove it's entry
			if(!S)
				living_defenders.Cut(defender_check_index, defender_check_index + 1)

			//see if it's dead/unconscious and we should respawn them
			else if(S.stat)

				//move it to the dead list
				living_defenders -= S
				dead_defenders += S

		//see if we need to manually respawn any defenders - because they have been gibbed or whatever
		if(living_defenders.len < defender_amount && num_respawns > 0)
			if(world.time >= time_next_respawn)
				//spawn a random new defender
				spawn_defender()
				time_next_respawn = world.time + respawn_interval
				num_respawns--

		//see if we've run out of time
		if(!instance_loaded && world.time > time_failed)
			finish_quest()
