
/datum/map/curie
	name = "Curie"
	full_name = "SSN Curie"
	path = "curie"

	lobby_icon = 'maps/exodus/exodus_lobby.dmi'

	load_legacy_saves = TRUE

	station_levels = list(1)
	admin_levels = list(2)
	contact_levels = list(1,4)
	player_levels = list(1,3,4,5,6)
	sealed_levels = list(2)
	accessible_z_levels = list("1" = 5, "3" = 5, "4" = 20, "5" = 20, "6" = 50)

	station_name  = "SSN Curie"
	station_short = "Curie"
	dock_name     = "SCNS Esperance"
	boss_name     = "Central Command"
	boss_short    = "Centcomm"
	company_name  = "NanoTrasen"
	company_short = "NT"

	shuttle_docked_message = "La navette de roulement arrivée de %Dock_name% s'est amarée à la station. Départ dans %ETD%"
	shuttle_leaving_dock = "La navette de roulement d'équipage s'est désamarée. Arrivé estimée dans %ETA%."
	shuttle_called_message = "Un roulement d'équipage vers %Dock_name% viens d'être planifié. Une navette de transfert a été appelée. Elle arrivera dans approximativement %ETA%"
	shuttle_recall_message = "Le roulement de l'équipage a été annulé."
	emergency_shuttle_docked_message = "La navette d'évacuation s'est amarrée à la station. Vous êtes prié d'évacuer d'ici %ETD%."
	emergency_shuttle_leaving_dock = "La navette d'évacuation s'est désamarée. Arrivé estimée dans %ETA%."
	emergency_shuttle_called_message = "La navette d'évacuation a été appelée. Elle arrivera dans approximativement %ETA%"
	emergency_shuttle_recall_message = "La navette d'évacuation a été rappelée. Le coût de cette manoevre sera déduit directement de vos salaires."

	evac_controller_type = /datum/evacuation_controller/shuttle

/datum/map/curie/perform_map_generation()
	new /datum/random_map/automata/cave_system(null,1,1,4,255,255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, 4, 64, 64)         // Create the mining ore distribution map.
	return 1
