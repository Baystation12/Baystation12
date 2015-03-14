/*
VOX HEIST ROUNDTYPE
*/

var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.

/datum/game_mode/heist
	antag_tag = MODE_RAIDER
	name = "heist"
	config_tag = "heist"
	required_players = 15
	required_players_secret = 25
	required_enemies = 4
	votable = 0
	round_description = "An unidentified bluespace signature has slipped past the Icarus and is approaching the station!"
	end_on_antag_death = 1

/datum/game_mode/heist/check_finished()
	if(!..())
		var/datum/shuttle/multi_shuttle/skipjack = shuttle_controller.shuttles["Vox Skipjack"]
		if (skipjack && skipjack.returned_home)
			return 1
	return 0

/datum/game_mode/heist/cleanup()
	//the skipjack and everything in it have left and aren't coming back, so get rid of them.
	var/area/skipjack = locate(/area/shuttle/vox/station)
	for (var/mob/living/M in skipjack.contents)
		//maybe send the player a message that they've gone home/been kidnapped? Someone responsible for vox lore should write that.
		del(M)
	for (var/obj/O in skipjack.contents)
		del(O)	//no hiding in lockers or anything