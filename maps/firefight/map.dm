
/datum/map/firefight_desert_outpost
	name = "Firefight: Desert Outpost"
	full_name = "Firefight gamemode on Desert Outpost map"
	path = "firefight_desert_outpost"
	allowed_gamemodes = list("firefight")
	id_hud_icons = 'firefight_hud_icons.dmi'
	lobby_icon = 'code/modules/halo/splashworks/title3.jpg'

	allowed_jobs = list(/datum/job/firefight_unsc_marine,
		/datum/job/firefight_colonist)
