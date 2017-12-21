/datum/map/torch
	name = "Torch"
	full_name = "SEV Torch"
	path = "torch"
	flags = MAP_HAS_BRANCH | MAP_HAS_RANK

	lobby_icon = 'maps/torch/icons/lobby.dmi'

	station_levels = list(1,2,3,4,5)
	contact_levels = list(1,2,3,4,5)
	player_levels = list(1,2,3,4,5,8)
	admin_levels = list(6,7)
	empty_levels = list(8)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=1,"5"=1,"8"=30)
	overmap_size = 40
	overmap_event_areas = 30
	usable_email_tlds = list("torch.ec.scg", "torch.fleet.mil", "torch.marine.mil", "freemail.nt")

	allowed_spawns = list("Cryogenic Storage", "Cyborg Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "SEV Torch"
	station_short = "Torch"
	dock_name     = "TBD"
	boss_name     = "Expeditionary Command"
	boss_short    = "Command"
	company_name  = "Sol Central Government"
	company_short = "SolGov"

	map_admin_faxes = list("NanoTrasen Central Office")

	//These should probably be moved into the evac controller...
	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	evac_controller_type = /datum/evacuation_controller/starship

	default_law_type = /datum/ai_laws/solgov
	use_overmap = 1
	num_exoplanets = 1
	planet_size = list(129,129)

	away_site_budget = 4

	id_hud_icons = 'maps/torch/icons/assignment_hud.dmi'
	lobby_screens = list("title","title2")

/datum/map/torch/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/torch/send_welcome()
	var/welcome_text = "<center><img src = sollogo.png /><br /><font size = 3><b>SEV Torch</b> Sensor Readings:</font><hr />"
	welcome_text += "Report generated on [stationdate2text()] at [stationtime2text()]</center><br /><br />"
	welcome_text += "Current system:<br /><b>[system_name()]</b><br />"
	welcome_text += "Next system targeted for jump:<br /><b>[generate_system_name()]</b><br />"
	welcome_text += "Travel time to Sol:<br /><b>[rand(15,45)] days</b><br />"
	welcome_text += "Time since last port visit:<br /><b>[rand(60,180)] days</b><br />"
	welcome_text += "Scan results:<br />"
	var/list/scan_results = list()
	for(var/poi in points_of_interest)
		if(poi == "SEV Torch")
			continue
		if(isnull(scan_results[poi]))
			scan_results[poi] = 1
		else
			scan_results[poi] += 1
	for(var/result in scan_results)
		var/count = scan_results[result]
		if(count == 1)
			welcome_text += "\A <b>[result]</b><br />"
		else
			welcome_text += "[count] <b>[result]\s</b><br />"

	post_comm_message("SEV Torch Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")


//Overriding event containers to remove random versions of overmap events - electrical storm, dust and meteor
/datum/event_container/mundane
	available_events = list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",			/datum/event/nothing,			100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",		/datum/event/apc_damage,		20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",/datum/event/brand_intelligence,10, 	list(ASSIGNMENT_JANITOR = 10),	1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",		/datum/event/camera_damage,		20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",		/datum/event/economic_event,	300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lost Carp",			/datum/event/carp_migration, 	20, 	list(ASSIGNMENT_SECURITY = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",		/datum/event/money_hacker, 		0, 		list(ASSIGNMENT_ANY = 4), 1, 10, 25),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",		/datum/event/money_lotto, 		0, 		list(ASSIGNMENT_ANY = 1), 1, 5, 15),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane News", 		/datum/event/mundane_news, 		300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Shipping Error",	/datum/event/shipping_error	, 	30, 	list(ASSIGNMENT_ANY = 2), 0),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Sensor Suit Jamming",/datum/event/sensor_suit_jamming,50,	list(ASSIGNMENT_MEDICAL = 20, ASSIGNMENT_AI = 20), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Trivial News",		/datum/event/trivial_news, 		400),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Vermin Infestation",/datum/event/infestation, 		100,	list(ASSIGNMENT_JANITOR = 100)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",			/datum/event/wallrot, 			0,		list(ASSIGNMENT_ENGINEER = 30, ASSIGNMENT_GARDENER = 50)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Space Cold Outbreak",/datum/event/space_cold,		100,	list(ASSIGNMENT_MEDICAL = 20)),
	)

/datum/event_container/moderate
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",					/datum/event/nothing,					1000),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 			/datum/event/spontaneous_appendicitis, 	0,		list(ASSIGNMENT_MEDICAL = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Communication Blackout",	/datum/event/communications_blackout,	500,	list(ASSIGNMENT_AI = 150, ASSIGNMENT_SECURITY = 120)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Failure",			/datum/event/gravity,	 				75,		list(ASSIGNMENT_ENGINEER = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Grid Check",				/datum/event/grid_check, 				200,	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Prison Break",				/datum/event/prison_break,				0,		list(ASSIGNMENT_SECURITY = 100)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Radiation Storm",			/datum/event/radiation_storm, 			0,		list(ASSIGNMENT_MEDICAL = 50), 1),
		new /datum/event_meta/extended_penalty(EVENT_LEVEL_MODERATE, "Random Antagonist",/datum/event/random_antag,		2.5,	list(ASSIGNMENT_SECURITY = 1), 1, 0, 5),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Rogue Drones",				/datum/event/rogue_drone, 				20,		list(ASSIGNMENT_SECURITY = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Sensor Suit Jamming",		/datum/event/sensor_suit_jamming,		10,		list(ASSIGNMENT_MEDICAL = 20, ASSIGNMENT_AI = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Solar Storm",				/datum/event/solar_storm, 				10,		list(ASSIGNMENT_ENGINEER = 20, ASSIGNMENT_SECURITY = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Spider Infestation",		/datum/event/spider_infestation, 		25,		list(ASSIGNMENT_SECURITY = 30), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Virology Breach",			/datum/event/prison_break/virology,		0,		list(ASSIGNMENT_MEDICAL = 100)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Xenobiology Breach",		/datum/event/prison_break/xenobiology,	0,		list(ASSIGNMENT_SCIENCE = 100)),
	)

/datum/event_container/major
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",				/datum/event/nothing,			1000),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Blob",				/datum/event/blob, 				0,	list(ASSIGNMENT_ENGINEER = 40), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Containment Breach",	/datum/event/prison_break/station,0,list(ASSIGNMENT_ANY = 5)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Space Vines",			/datum/event/spacevine, 		0,	list(ASSIGNMENT_ENGINEER = 15), 1),
	)
