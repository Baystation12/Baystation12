/datum/map/overmap_example
	name = "Overmap Example"
	full_name = "The Overmap Example"
	path = "overmap_example"

	station_name  = "CSV Bearcat"
	station_short = "Bearcat"

	dock_name     = "TSS Capitalist's Rest"
	boss_name     = "FTU Merchant Navy"
	boss_short    = "Merchant Admiral"
	company_name  = "Legit Cargo Ltd."
	company_short = "LC"

	evac_controller_type = /datum/evacuation_controller/starship
	lobby_icon = 'maps/overmap_example/overmap_example_lobby.dmi'

	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"
	use_overmap = 1
	welcome_sound = 'sound/effects/cowboysting.ogg'