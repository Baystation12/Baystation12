/datum/map/Insurrection
	name = "Sector 0442: New Antartica"
	full_name = "Sector 0442: New Antartica"
	path = "Insurrection"
	station_levels = list()
	admin_levels = list()
	accessible_z_levels = list()
	//lobby_icon = 'maps/example/example_lobby.dmi'
	lobby_icon = 'code/modules/halo/splashworks/title6.png'
	id_hud_icons = 'maps/unsc_frigate/frigate_hud_icons.dmi'
	station_networks = list("Exodus")
	station_name  = ""
	station_short = ""
	dock_name     = "Shuttle Dock"
	boss_name     = "United Nations Space Command"
	boss_short    = "UNSC HIGHCOM"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"
	system_name = "Sector 0442: New Antartica"
	overmap_size= 3

	use_overmap = 1



/datum/map/Insurrection
	allowed_jobs = list(/datum/job/UNSC_assault,/datum/job/UNSC_Squad_Lead,/datum/job/UNSC_Team_Lead,/datum/job/Insurrectionist,/datum/job/Insurrectionist_leader,)
	allowed_spawns = list("Insurrectionist","Insurrectionist Leader","ODST Assault Squad Lead","ODST Assault Squad Member","ODST Assault Team Lead",)
