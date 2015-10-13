/*
VOX HEIST ROUNDTYPE
*/

var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.

/datum/game_mode/heist
	antag_tag = MODE_RAIDER
	name = "heist"
	config_tag = "heist"
	required_players = 15
	required_enemies = 4
	round_description = "An unidentified bluespace signature has slipped past the Icarus and is approaching the station!"
	end_on_antag_death = 1

/datum/game_mode/heist/check_finished()
	if(!..())
		var/datum/shuttle/multi_shuttle/skipjack = shuttle_controller.shuttles["Skipjack"]
		if (skipjack && skipjack.returned_home)
			return 1
	return 0
