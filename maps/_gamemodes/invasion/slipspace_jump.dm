
/datum/game_mode/outer_colonies/handle_slipspace_jump(var/obj/effect/overmap/ship/ship)

	var/obj/effect/overmap/flagship
	var/datum/faction/F = GLOB.factions_by_name[ship.faction]
	if(F)
		flagship = F.get_flagship()

	if(flagship == ship)
		//record a round end condition
		F.flagship_slipspaced = 1

		//lock in any covenant objectives now so they arent failed by the ship despawning
		for(var/datum/objective/objective in objectives_slipspace_affected)

			//a 1 here means the objective was successful
			objective.override = objective.check_completion()

			//a 0 means it fails so we set -1 to lock in a 0 result
			if(!objective.override)
				objective.override = -1

		check_finished()
