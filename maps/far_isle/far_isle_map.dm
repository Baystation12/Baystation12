
/datum/map/far_isle
	name = "Far Isle"
	full_name = "Far Isle Colony"
	path = "far_isle"
	station_levels = list(1,2,3)
	admin_levels = list()
	accessible_z_levels = list()
	//lobby_icon = 'maps/example/example_lobby.dmi'
	lobby_icon = 'code/modules/halo/splashworks/title6.png'
	id_hud_icons = 'maps/insurrection/insurrection_hud_icons.dmi'

	station_name  = "Far Isle Colony"
	station_short = "Far Isle"
	dock_name     = "Landing Pad"
	boss_name     = "Mayor"
	boss_short    = "Mayor"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"
	system_name = "Uncharted System"

	allowed_jobs = list(/datum/job/Insurrectionist,/datum/job/Insurrectionist_leader,/datum/job/UNSC_assault,/datum/job/UNSC_Squad_Lead,/datum/job/UNSC_Team_Lead)

	allowed_spawns = list("Insurrectionist","Insurrectionist Leader","ODST Assault Squad Member","ODST Assault Squad Lead","ODST Assault Team Lead")

	default_spawn = "Insurrectionist"
