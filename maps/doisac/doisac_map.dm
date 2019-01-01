
/datum/map/doisac
	name = "Doisac"
	full_name = "Oth Sonin III \'Doisac\'"
	path = "doisac"
	lobby_icon = 'code/modules/halo/splashworks/brutes.jpg'
	id_hud_icons = 'packwar_hud_icons.dmi'
	station_name  = "Doisac"
	station_short = "Doisac"
	dock_name     = "Landing Pad"
	boss_name     = "Mayor"
	boss_short    = "Mayor"
	company_name  = "Jiralhanae Alpha Pack"
	company_short = "Jiralhanae Alpha"
	system_name = "Oth Sonin"

	allowed_jobs = list(\
	/datum/job/packwar_chieftain_ram,\
	/datum/job/packwar_captain_ram,\
	/datum/job/packwar_major_ram,\
	/datum/job/packwar_minor_ram,\
	/datum/job/packwar_thrall_ram,\
	/datum/job/packwar_chieftain_boulder,\
	/datum/job/packwar_captain_boulder,\
	/datum/job/packwar_major_boulder,\
	/datum/job/packwar_minor_boulder,\
	/datum/job/packwar_thrall_boulder,\
	/datum/job/packwar_runt,\
	/datum/job/packwar_merc/skirmisher,\
	/datum/job/packwar_merc/skirmisher/ram,\
	/datum/job/packwar_merc/skirmisher/champion,\
	/datum/job/packwar_merc/skirmisher/champion/ram,\
	/datum/job/packwar_merc/jackal,\
	/datum/job/packwar_merc/jackal/ram,\
	/datum/job/packwar_merc/jackal/sniper,\
	/datum/job/packwar_merc/jackal/sniper/ram\
	)
	allowed_spawns = list(DEFAULT_SPAWNPOINT_ID)
	default_spawn = DEFAULT_SPAWNPOINT_ID

/*
/datum/map/doisac/New()
	. = ..()
	lobby_icon = pick(\
		'code/modules/halo/splashworks/title6.png'\
	)
	*/
