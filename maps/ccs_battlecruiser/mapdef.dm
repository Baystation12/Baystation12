
/datum/map/covenant_cruiser
	name = "CCS Battlecruiser"
	full_name = "CCS Battlecruiser"
	path = "covenant_cruiser"
	lobby_icon = 'code/modules/halo/splashworks/covenant.png'
	id_hud_icons = 'maps/ccs_battlecruiser/opr_hud_icons.dmi'

	station_name  = ""
	station_short = ""
	dock_name     = ""
	boss_name     = "High Council of the Covenant"
	boss_short    = "Covenant Council"
	company_name  = "Covenant"
	company_short = "Covenant"
	system_name = "Uncharted System"
	overmap_size= 60
	allowed_jobs = list(\
		/datum/job/opredflag_elite,\
		/datum/job/opredflag_elite/major,\
		/datum/job/opredflag_elite/ultra,\
		/datum/job/opredflag_elite/shipmaster,\
		/datum/job/opredflag_elite/zealot,\
		/datum/job/opredflag_elite/ranger,\
		/datum/job/opredflag_elite/specops,\
		/datum/job/opredflag_grunt,\
		/datum/job/opredflag_grunt/major,\
		/datum/job/opredflag_grunt/ultra,\
		/datum/job/opredflag_grunt/specops,\
		/datum/job/opredflag_jackal,\
		/datum/job/opredflag_spartan,\
		/datum/job/opredflag_spartan/commander\
	)

	//use_overmap = 1
	allowed_spawns = list(DEFAULT_SPAWNPOINT_ID, "Arrivals Shuttle")
	default_spawn = "Arrivals Shuttle"



/datum/map/covenant_cruiser/New()
	. = ..()
	name = pick(GLOB.covenant_ship_names)
	full_name = "CCS Battlecruiser \"[name]\""
