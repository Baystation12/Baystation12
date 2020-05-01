
/datum/map/firefight
	company_name  = "United Nations Space Command"
	company_short = "UNSC"

	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'
	id_hud_icons = 'maps/desert_outpost/stranded_hud_icons.dmi'
	allowed_gamemodes = list("firefight","crusade","stranded")
	use_overmap = 0

	allowed_jobs = list(\
		//Covenant jobs
		/datum/job/covenant/brute_captain,\
		/datum/job/covenant/brute_major,\
		/datum/job/covenant/brute_minor,\
		//
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyar_marksman,\
		/datum/job/covenant/kigyar_sniper,\
		//
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/sangheili_ultra,\
		/datum/job/covenant/sangheili_honour_guard,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_specops,\
		/datum/job/covenant/sangheili_zealot,\
		//
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmmurmillo,\
		/datum/job/covenant/skirmcommando,\
		/datum/job/covenant/skirmchampion,\
		//
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major,\
		/datum/job/covenant/unggoy_ultra,\
		/datum/job/covenant/unggoy_deacon,\
		/datum/job/covenant/unggoy_specops,\
		//
		/datum/job/covenant/yanmee_minor,\
		/datum/job/covenant/yanmee_major,\
		/datum/job/covenant/yanmee_ultra,\
		/datum/job/covenant/yanmee_leader,\

		//UNSC jobs
		/datum/job/firefight_unsc_marine,\
		/datum/job/firefight_colonist,\

		//UNSC survivor jobs
		/datum/job/stranded/unsc_marine,\
		/datum/job/stranded/unsc_tech,\
		/datum/job/stranded/unsc_medic,\
		/datum/job/stranded/unsc_crew,\
		/datum/job/stranded/unsc_civ\
		)
