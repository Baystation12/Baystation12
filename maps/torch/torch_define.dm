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

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")

	shuttle_docked_message = "Bluespace drive has been spooled up, prepare for launch. Time to jump, approximately %ETD%."
	shuttle_leaving_dock = "Jump initiated, entering bluespace in %ETA%."
	shuttle_called_message = "All hands, bluespace drive is spooling up. Jump in %ETA%."
	shuttle_recall_message = "Jump sequence aborted, please return to your duties."
	emergency_shuttle_docked_message = "Emergency escape pods are prepped. You have %ETD% to board the emergency escape pods."
	emergency_shuttle_leaving_dock = "Emergency escape pods are launched, arriving at rendezvous point in %ETA%."
	emergency_shuttle_called_message = "Emergency escape pods are being prepped. ETA %ETA%"
	emergency_shuttle_recall_message = "Emergency escape sequence aborted, please return to your duties."

	// Networks that will show up as options in the camera monitor program
	station_networks = list(
							NETWORK_CALYPSO,
							NETWORK_ENGINE,
							NETWORK_EXPEDITION,
							NETWORK_FIRST_DECK,
							NETWORK_FOURTH_DECK,
							NETWORK_ROBOTS,
							NETWORK_POD,
							NETWORK_SECOND_DECK,
							NETWORK_THIRD_DECK,
							NETWORK_SUPPLY,
							NETWORK_COMMAND,
							NETWORK_ENGINEERING,
							NETWORK_MEDICAL,
							NETWORK_RESEARCH,
							NETWORK_SECURITY,
							NETWORK_PRISON,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_FIRE,
							NETWORK_ALARM_POWER,
							NETWORK_THUNDER,
							)
	evac_controller_type = /datum/evacuation_controller/pods
	
/datum/map/torch/perform_map_generation()
	new /datum/random_map/automata/cave_system(null,1,1,7,255,255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null,1,1,7,64, 64)             // Create the mining ore distribution map.
	return 1
