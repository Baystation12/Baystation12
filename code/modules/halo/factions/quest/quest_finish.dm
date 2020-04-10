
/datum/npc_quest/proc/check_quest_objective()
	//check if any victory conditions are filled
	switch(quest_type)
		if(OBJ_KILL)
			//kill simple mobs
			if(instance_area)
				if(!living_defenders.len && !num_respawns)
					faction.finalise_quest(src, STATUS_WON)
					return 1

		if(OBJ_ASSASSINATE)
			//kill VIP simple mob
			if(instance_area)
				if(!vip_mob || vip_mob.stat == DEAD)
					faction.finalise_quest(src, STATUS_WON)
					return 1

		if(OBJ_STEAL)
			//retrieve item
			if(instance_area)
				var/all_items_retrieved = 1
				for(var/atom/movable/AM in target_items)
					if(get_area(AM) == instance_area)
						all_items_retrieved = 0
						break

				if(all_items_retrieved)
					faction.finalise_quest(src, STATUS_WON)
					return 1
