/datum/game_mode/sandbox
	name = "sandbox"
	config_tag = "sandbox"
	required_players = 0
	votable = 0

/datum/game_mode/sandbox/announce()
	world << "<B>The current game mode is - Sandbox!</B>"
	world << "<B>Build your own station with the sandbox-panel command!</B>"

/datum/game_mode/sandbox/pre_setup()
	for(var/mob/M in world)
		if(M.client)
			M.CanBuild()

	setup_sectors()
	spawn_exporation_packs()
	return 1

/datum/game_mode/sandbox/check_finished()
	return 0
