
/datum/map/desert_outpost
	name = "Desert Outpost"
	full_name = "Unknown Desert Outpost"
	path = "desert_outpost"

	station_name  = "Unknown desert world"
	station_short = "Unknown desert world"
	company_name  = "United Nations Space Command"
	company_short = "UNSC"
	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'

	id_hud_icons = 'stranded_hud_icons.dmi'

	allowed_spawns = list("Crash Site")

	allowed_jobs = list(\
		/datum/job/stranded/unsc_marine,\
		/datum/job/stranded/unsc_tech,\
		/datum/job/stranded/unsc_medic,\
		/datum/job/stranded/unsc_crew,\
		/datum/job/stranded/unsc_civ)
