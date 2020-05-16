
/datum/map/stranded_desert_outpost
	name = "Stranded: Desert Outpost"
	full_name = "Stranded gamemode on Desert Outpost map"
	path = "stranded_desert_outpost"
	allowed_gamemodes = list("stranded")
	id_hud_icons = 'stranded_hud_icons.dmi'
	lobby_icon = 'code/modules/halo/splashworks/title4.jpg'

	allowed_gamemodes = list("stranded")
	allowed_jobs = list(\
		/datum/job/unsc/marine/firefight,\
		/datum/job/unsc/marine/squad_leader/firefight,\
		/datum/job/unsc/odst/firefight,\
		/datum/job/unsc/odst/squad_leader/firefight,\
		/datum/job/unsc/spartan2/firefight,\
		/datum/job/unsc/firefight_colonist)
