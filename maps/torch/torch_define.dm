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

	shuttle_docked_message = "Bluespace drive has been spooled up, prepare for launch. Time to jump, approximately %ETD%."
	shuttle_leaving_dock = "Jump initiated, entering bluespace in %ETA%."
	shuttle_called_message = "All hands, bluespace drive is spooling up. Jump in %ETA%."
	shuttle_recall_message = "Jump sequence aborted, please return to your duties."
	emergency_shuttle_docked_message = "Emergency escape pods are prepped. You have %ETD% to board the emergency escape pods."
	emergency_shuttle_leaving_dock = "Emergency escape pods are launched, arriving at rendezvous point in %ETA%."
	emergency_shuttle_called_message = "Emergency escape pods are being prepped. ETA %ETA%"
	emergency_shuttle_recall_message = "Emergency escape sequence aborted, please return to your duties."

	evac_controller_type = /datum/evacuation_controller/pods

/datum/map/torch/perform_map_generation()
	new /datum/random_map/automata/cave_system(null,1,1,7,255,255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null,1,1,7,64, 64)             // Create the mining ore distribution map.
	return 1
