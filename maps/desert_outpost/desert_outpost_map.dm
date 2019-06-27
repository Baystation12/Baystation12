
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

	allowed_jobs = list(\
		/datum/job/stranded_unsc_marine,\
		/datum/job/stranded_unsc_tech,\
		/datum/job/stranded_unsc_medic,\
		/datum/job/stranded_unsc_crew,\
		/datum/job/stranded_unsc_civ)
