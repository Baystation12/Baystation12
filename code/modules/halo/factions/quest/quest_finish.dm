
/datum/npc_quest/proc/finish_quest()

	if(quest_status == STATUS_PROGRESS)
		quest_status = STATUS_FAIL
		switch(quest_type)
			if(OBJ_KILL)
				//kill simple mobs
				if(!living_defenders.len && !num_respawns)
					quest_status = STATUS_WON

			if(OBJ_ASSASSINATE)
				//kill VIP simple mob
				if(!vip_mob || vip_mob.stat == DEAD)
					quest_status = STATUS_WON

			if(OBJ_STEAL)
				//retrieve item
				if(instance_area)
					var/all_items_retrieved = 1
					for(var/atom/movable/AM in target_items)
						if(get_area(AM) == instance_area)
							all_items_retrieved = 0
							break

					if(all_items_retrieved)
						quest_status = STATUS_WON

		if(quest_status == STATUS_FAIL && world.time > time_failed)
			quest_status = STATUS_TIMEOUT

		GLOB.factions_controller.active_quest_coords.Remove(coords)
		qdel(coords)

	if(faction)
		faction.complete_quest(src)
		attempting_faction.update_reputation_gear(faction)
		faction.generate_rep_rewards(faction.get_faction_reputation(attempting_faction.name))
