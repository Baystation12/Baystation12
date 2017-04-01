
/datum/map/april
	name = "Vault 12"
	full_name = "Nanotrasen Vault 12"
	path = "april"

	lobby_icon = 'maps/april/april_lobby.dmi'

	load_legacy_saves = TRUE

	station_levels = list(1, 2)
	admin_levels = list(5)
	contact_levels = list(1,2)
	player_levels = list(1,2,3,4)
	sealed_levels = list(1,2)
	empty_levels = list(4)
	accessible_z_levels = list("4" = 60, "3"= 40)
	base_turf_by_z = list("1" = /turf/simulated/floor/underground, "2" = /turf/simulated/floor/underground, "3" = /turf/wasteland, "4" = /turf/wasteland)

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage", "Wander the Wastes")

	station_name  = "Vault 12"
	station_short = "Vault 12"
	dock_name     = "Mars Transfer Vehicle"
	boss_name     = "Vault Command"
	boss_short    = "Vaultcomm"
	company_name  = "NanoTrasen"
	company_short = "NT"
	system_name = "Sol"

	shuttle_docked_message = "The Vault Dweller Evacuation System is now fully armed. All Vault Dwellers should board at this time. It will depart in approximately %ETD%"
	shuttle_leaving_dock = "The Vault Dweller Evacuation System has left the vault. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "The %Dock_name% has announced an activation of the Vault Dweller Evacuation System. Entry doors will unlock in %ETA%"
	shuttle_recall_message = "The %Dock_name% has announced a cancellation of the Vault Dweller Evacuation System launch operations."
	emergency_shuttle_docked_message = "The Vault Dweller Evacuation System is now fully armed. All Vault Dwellers should board at this time. It will depart in approximately %ETD%"
	emergency_shuttle_leaving_dock = "The Vault Dweller Evacuation System has left the vault. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "The Overseer has called for an emergency launch of the Vault Dweller Evacuation System. Entry doors will unlock in %ETA%"
	emergency_shuttle_recall_message = "The Overseer has cancelled an emergency early launch. Please return to your normal assigned duties."

	evac_controller_type = /datum/evacuation_controller/shuttle

/datum/map/april/perform_map_generation()
	new /datum/random_map/automata/cave_system(null, 1, 1, 1, 255, 255) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, 1, 64, 64)         // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system(null, 19, 206, 2, 40, 227) // Create the main underground Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, 2, 64, 64)         // Create the ore distribution map.
	new /datum/random_map/automata/cave_system(null, 1, 180, 3, 119, 255) // Create the surface Z-level.
	return 1