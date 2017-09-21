/datum/map/torch
	name = "Torch"
	full_name = "SEV Torch"
	path = "torch"
	flags = MAP_HAS_BRANCH | MAP_HAS_RANK

	lobby_icon = 'maps/torch/icons/lobby.dmi'

	station_levels = list(1,2,3,4,5)
	contact_levels = list(1,2,3,4,5)
	player_levels = list(1,2,3,4,5,6,7,8,9)
	admin_levels = list(10,11)
	empty_levels = list(6)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=1,"5"=1,"6"=30,"7"=10,"8"=10)
	overmap_size = 40
	overmap_event_areas = 12
	base_turf_by_z = list("9" = /turf/simulated/floor/asteroid)
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

	id_hud_icons = 'maps/torch/icons/assignment_hud.dmi'

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



/datum/map/torch/perform_map_generation()
	new /datum/random_map/automata/cave_system(null,1,1,7,world.maxx,world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null,1,1,7,64, 64)             // Create the mining ore distribution map.
	new /datum/random_map/automata/cave_system(null,1,1,9,world.maxx,world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null,1,1,9,64, 64)             // Create the mining ore distribution map.
	return 1
