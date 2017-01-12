/datum/map/torch
	name = "Torch"
	full_name = "SEV Torch"
	path = "torch"
	flags = MAP_HAS_BRANCH | MAP_HAS_RANK

	lobby_icon = 'maps/torch/torch_lobby.dmi'

	station_levels = list(1,2,3,4,5)
	contact_levels = list(1,2,3,4,5)
	player_levels = list(1,2,3,4,5,6,7,8,9)
	admin_levels = list(10)

	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=1,"5"=1,"6"=30)

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")

	station_name  = "SEV Torch"
	station_short = "Torch"
	dock_name     = "TBD"
	boss_name     = "Expeditionary Command"
	boss_short    = "Command"
	company_name  = "Sol Central Government"
	company_short = "SolGov"

	shuttle_docked_message = "Attention all hands: the Bluespace drive has been spooled up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting Bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: the Bluespace drive is spooling up. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."
	emergency_shuttle_docked_message = "Attention all hands: the escape pods are now unlocked. You have %ETD% to board the escape pods."
	emergency_shuttle_leaving_dock = "Attention all hands: the escape pods have been launched, arriving at rendezvous point in %ETA%."
	emergency_shuttle_called_message = "Attention all hands: emergecy evacuation procedures are now in effect. Escape pods will unlock in %ETA%"
	emergency_shuttle_recall_message = "Attention all hands: emergency evacuation sequence aborted. Return to normal operating conditions."

	evac_controller_type = /datum/evacuation_controller/pods

	default_law_type = /datum/ai_laws/solgov

/datum/map/torch/perform_map_generation()
	new /datum/random_map/automata/cave_system(null,1,1,7,255,255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null,1,1,7,64, 64)             // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system(null,1,1,9,255,255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null,1,1,9,64, 64)             // Create the mining ore distribution map.
	return 1
