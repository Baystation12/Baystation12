
/datum/map/geminus_city
	name = "Geminus"
	full_name = "Geminus City"

	path = "geminus_city"
	station_levels = list()
	admin_levels = list()
	accessible_z_levels = list()
	//lobby_icon = 'maps/example/example_lobby.dmi'
	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'
	id_hud_icons = 'maps/geminus_city/geminus_hud_icons.dmi'

	station_name  = "Geminus City"
	station_short = "Geminus"
	dock_name     = "Landing Pad"
	boss_name     = "Mayor"
	boss_short    = "Mayor"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"
	system_name = "Uncharted System"
	overmap_size= 100

	use_overmap = 1
	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID)
