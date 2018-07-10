/datum/map/torch
	name = "Torch"
	full_name = "SEV Torch"
	path = "torch"
	flags = MAP_HAS_BRANCH | MAP_HAS_RANK

	station_levels = list(1,2,3,4,5)
	contact_levels = list(1,2,3,4,5)
	player_levels = list(1,2,3,4,5,8)
	admin_levels = list(6,7)
	empty_levels = list(8)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=1,"5"=1,"8"=30)
	overmap_size = 35
	overmap_event_areas = 34
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

	away_site_budget = 3

	citizenship_choices = list(
		"Earth",
		"Luna",
		"Mars",
		"Terra",
		"Gaia",
		"Moghes",
		"Ahdomai",
		"Qerrbalak",
		"Tersten",
		"Avalon",
		"Yuklid",
		"Venus",
		"Cinu",
		"Tau-Wilo",
		"Ceres",
		"Galilei"
	)

	home_system_choices = list(
		"Sol",
		"Nyx",
		"Tau Ceti",
		"Epsilon Ursae Minoris",
		"Zamsiin-lr",
		"Gilgamesh",
		"Gavil",
		"Uuoea-Esa",
		"Kernel",
		"Gessshire",
		"Galilei"
		)

	faction_choices = list(
		"Sol Central Government",
		"Terran Colonial Confederation",
		"Vey Med",
		"Einstein Engines",
		"Free Trade Union",
		"NanoTrasen",
		"Ward-Takahashi GMB",
		"Gilthari Exports",
		"Grayson Manufactories Ltd.",
		"Aether Atmospherics",
		"Zeng-Hu Pharmaceuticals",
		"Hephaestus Industries",
		"Commonwealth of Ahdomai",
		"Xynergy",
		"Positronic Union"
		)

	religion_choices = list(
		"Jewish",
		"Hinduism",
		"Buddhist",
		"Islamic",
		"Christian",
		"Agnostic",
		"Deist",
		"Athiest",
		"Thelema",
		"Spiritualist"
		)

	id_hud_icons = 'maps/torch/icons/assignment_hud.dmi'

/datum/map/torch/setup_map()
	..()
	system_name = generate_system_name()
	minor_announcement = new(new_sound = sound('sound/AI/torch/commandreport.ogg', volume = 45))

/datum/map/torch/map_info(victim)
	to_chat(victim, "<h2>Current map information</h2>")
	to_chat(victim, "You're aboard the <b>[station_name]</b>, an Expeditionary Corps vessel. Its primary mission is looking for undiscovered sapient alien species, and general exploration along the way.")
	to_chat(victim, "The vessel is staffed with a mix of SCG government personnel, hired contractors and NanoTrasen employees.")
	to_chat(victim, "This area of space is uncharted, away from SCG territory. You might encounter remote outposts or drifting hulks, but no recognized government holds claim on this sector.")

/datum/map/torch/send_welcome()
	var/welcome_text = "<center><img src = sollogo.png /><br /><font size = 3><b>SEV Torch</b> Sensor Readings:</font><hr />"
	welcome_text += "Report generated on [stationdate2text()] at [stationtime2text()]</center><br /><br />"
	welcome_text += "Current system:<br /><b>[system_name()]</b><br />"
	welcome_text += "Next system targeted for jump:<br /><b>[generate_system_name()]</b><br />"
	welcome_text += "Travel time to Sol:<br /><b>[rand(15,45)] days</b><br />"
	welcome_text += "Time since last port visit:<br /><b>[rand(60,180)] days</b><br />"
	welcome_text += "Scan results show the following points of interest:<br />"
	var/list/space_things = list()
	var/obj/effect/overmap/torch = map_sectors["1"]
	for(var/zlevel in map_sectors)
		var/obj/effect/overmap/O = map_sectors[zlevel]
		if(O.name == torch.name)
			continue
		space_things |= O

	for(var/obj/effect/overmap/O in space_things)
		var/location_desc = " at present co-ordinates."
		if (O.loc != torch.loc)
			var/bearing = round(90 - Atan2(O.x - torch.x, O.y - torch.y),5) //fucking triangles how do they work
			if(bearing < 0)
				bearing += 360
			location_desc = ", bearing [bearing]."
		welcome_text += "<li>\A <b>[O.name]</b>[location_desc]</li>"
	welcome_text += "<br>No distress calls logged.<br />"

	post_comm_message("SEV Torch Sensor Readings", welcome_text)
	minor_announcement.Announce(message = "New [GLOB.using_map.company_name] Update available at all communication consoles.")

/turf/simulated/wall //landlubbers go home
	name = "bulkhead"

/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/decl/flooring/tiling
	name = "deck"