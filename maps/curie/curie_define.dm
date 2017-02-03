
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

	shuttle_docked_message = "La navette de roulement arriv�e de %Dock_name% s'est amar�e � la station. D�part dans %ETD%"
	shuttle_leaving_dock = "La navette de roulement d'�quipage s'est d�samar�e. Arriv� estim�e dans %ETA%."
	shuttle_called_message = "Un roulement d'�quipage vers %Dock_name% viens d'�tre planifi�. Une navette de transfert a �t� appel�e. Elle arrivera dans approximativement %ETA%"
	shuttle_recall_message = "Le roulement de l'�quipage a �t� annul�."
	emergency_shuttle_docked_message = "La navette d'�vacuation s'est amarr�e � la station. Vous �tes pri� d'�vacuer d'ici %ETD%."
	emergency_shuttle_leaving_dock = "La navette d'�vacuation s'est d�samar�e. Arriv� estim�e dans %ETA%."
	emergency_shuttle_called_message = "La navette d'�vacuation a �t� appel�e. Elle arrivera dans approximativement %ETA%"
	emergency_shuttle_recall_message = "La navette d'�vacuation a �t� rappel�e. Le co�t de cette manoevre sera d�duit directement de vos salaires."

	station_networks = list(
							NETWORK_CIVILIAN_EAST,
							NETWORK_CIVILIAN_WEST,
							NETWORK_SUPPLY,
							NETWORK_COMMAND,
							NETWORK_ENGINEERING,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_RESEARCH,
							NETWORK_ROBOTS,
							NETWORK_SECURITY,
							NETWORK_ALARM_ATMOS,
							NETWORK_ALARM_FIRE,
							NETWORK_ALARM_POWER,
							NETWORK_THUNDER,
							NETWORK_TELECOM,
							)

	evac_controller_type = /datum/evacuation_controller/shuttle

/datum/map/curie/perform_map_generation()
	new /datum/random_map/automata/cave_system(null,1,1,4,255,255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, 4, 64, 64)         // Create the mining ore distribution map.
	return 1
