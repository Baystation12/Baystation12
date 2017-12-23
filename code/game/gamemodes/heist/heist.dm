/*
(VOX) HEIST ROUNDTYPE
*/

/datum/game_mode/heist
	name = "Heist"
	config_tag = "heist"
	required_players = 12
	required_enemies = 4
	round_description = "An unidentified bluespace signature has slipped into close sensor range and is approaching!"
	extended_round_description = "The Company's majority control of phoron in Nyx has marked the \
		station to be a highly valuable target for many competing organizations and individuals. Being a \
		colony of sizable population and considerable wealth causes it to often be the target of various \
		attempts of robbery, fraud and other malicious actions."
	end_on_antag_death = 1
	antag_tags = list(MODE_RAIDER)

/datum/game_mode/heist/check_finished()
	var/datum/shuttle/autodock/multi/antag/skipjack = shuttle_controller.shuttles["Skipjack"]
	if (skipjack && skipjack.return_warning && skipjack.home_waypoint == skipjack.current_location)
		return 1
	return ..()
