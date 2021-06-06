/*
	MERCENARY ROUNDTYPE
*/

GLOBAL_LIST_EMPTY(nuke_disks)

/datum/game_mode/nuclear
	name = "Mercenary"
	round_description = "A mercenary strike force is approaching!"
	extended_round_description = "The Company's majority control of phoron in Nyx has marked the \
		station to be a highly valuable target for many competing organizations and individuals. Being a \
		colony of sizable population and considerable wealth causes it to often be the target of various \
		attempts of robbery, fraud and other malicious actions."
	config_tag = "mercenary"
	required_players = 15
	required_enemies = 3
	end_on_antag_death = FALSE
	var/nuke_off_station = 0 //Used for tracking if the syndies actually haul the nuke to the station
	var/syndies_didnt_escape = 0 //Used for tracking if the syndies got the shuttle off of the z-level
	antag_tags = list(MODE_MERCENARY)
	cinematic_icon_states = list(
		"intro_nuke" = 35,
		"summary_nukewin",
		"summary_nukefail"
	)
	var/syndicate_name

/datum/game_mode/nuclear/New()
	..()
	syndicate_name = pick(list(
		"Clandestine", "Prima", "Blue", "Zero-G",
		"Max", "Blasto", "Waffle", "North",
		"Omni", "Newton", "Cyber", "Bonk",
		"Gene", "Gib"
	))
	if (prob(80))
		syndicate_name += " "
		if (prob(60))
			syndicate_name += pick(list(
				"Syndicate", "Consortium", "Collective", "Corporation",
				"Group", "Holdings", "Biotech", "Industries",
				"Systems", "Products", "Chemicals", "Enterprises",
				"Family", "Creations", "International", "Intergalactic",
				"Interplanetary", "Foundation", "Positronics", "Hive"
			))
		else
			syndicate_name += pick(list(
				"Syndi", "Corp", "Bio", "System",
				"Prod", "Chem", "Inter", "Hive"
			))
			syndicate_name += pick("", "-")
			syndicate_name += pick(list(
				"Tech", "Sun", "Co", "Tek",
				"X", "Inc", "Code"
			))
	else
		syndicate_name += pick("-", "*", "")
		syndicate_name += pick(list(
			"Tech", "Sun", "Co", "Tek",
			"X", "Inc", "Gen", "Star",
			"Dyne", "Code", "Hive"
		))


//checks if L has a nuke disk on their person
/datum/game_mode/nuclear/proc/check_mob(mob/living/L)
	for(var/obj/item/disk/nuclear/N in GLOB.nuke_disks)
		if(N.storage_depth(L) >= 0)
			return TRUE
	return FALSE

/datum/game_mode/nuclear/declare_completion()
	var/datum/antagonist/merc = GLOB.all_antag_types_[MODE_MERCENARY]
	if(config.objectives_disabled == CONFIG_OBJECTIVE_NONE || (merc && !merc.global_objectives.len))
		..()
		return
	var/disk_rescued = TRUE
	for(var/obj/item/disk/nuclear/D in world)
		var/disk_area = get_area(D)
		if(!is_type_in_list(disk_area, GLOB.using_map.post_round_safe_areas))
			disk_rescued = FALSE
			break
	var/crew_evacuated = GLOB.evacuation_controller.has_evacuated()

	if(!disk_rescued &&  station_was_nuked && !syndies_didnt_escape)
		SSstatistics.set_field_details("round_end_result","win - syndicate nuke")
		to_world("<FONT size = 3><B>Mercenary Major Victory!</B></FONT>")
		to_world("<B>[syndicate_name] operatives have destroyed [station_name()]!</B>")

	else if (!disk_rescued &&  station_was_nuked && syndies_didnt_escape)
		SSstatistics.set_field_details("round_end_result","halfwin - syndicate nuke - did not evacuate in time")
		to_world("<FONT size = 3><B>Total Annihilation</B></FONT>")
		to_world("<B>[syndicate_name] operatives destroyed [station_name()] but did not leave the area in time and got caught in the explosion.</B> Next time, don't lose the disk!")

	else if (!disk_rescued && !station_was_nuked &&  nuke_off_station && !syndies_didnt_escape)
		SSstatistics.set_field_details("round_end_result","halfwin - blew wrong station")
		to_world("<FONT size = 3><B>Crew Minor Victory</B></FONT>")
		to_world("<B>[syndicate_name] operatives secured the authentication disk but blew up something that wasn't [station_name()].</B> Next time, don't lose the disk!")

	else if (!disk_rescued && !station_was_nuked &&  nuke_off_station && syndies_didnt_escape)
		SSstatistics.set_field_details("round_end_result","halfwin - blew wrong station - did not evacuate in time")
		to_world("<FONT size = 3><B>[syndicate_name] operatives have earned Darwin Award!</B></FONT>")
		to_world("<B>[syndicate_name] operatives blew up something that wasn't [station_name()] and got caught in the explosion.</B> Next time, don't lose the disk!")

	else if (disk_rescued && GLOB.mercs.antags_are_dead())
		SSstatistics.set_field_details("round_end_result","loss - evacuation - disk secured - syndi team dead")
		to_world("<FONT size = 3><B>Crew Major Victory!</B></FONT>")
		to_world("<B>The Research Staff has saved the disc and killed the [syndicate_name] Operatives</B>")

	else if ( disk_rescued                                        )
		SSstatistics.set_field_details("round_end_result","loss - evacuation - disk secured")
		to_world("<FONT size = 3><B>Crew Major Victory</B></FONT>")
		to_world("<B>The Research Staff has saved the disc and stopped the [syndicate_name] Operatives!</B>")

	else if (!disk_rescued && GLOB.mercs.antags_are_dead())
		SSstatistics.set_field_details("round_end_result","loss - evacuation - disk not secured")
		to_world("<FONT size = 3><B>Mercenary Minor Victory!</B></FONT>")
		to_world("<B>The Research Staff failed to secure the authentication disk but did manage to kill most of the [syndicate_name] Operatives!</B>")

	else if (!disk_rescued && crew_evacuated)
		SSstatistics.set_field_details("round_end_result","halfwin - detonation averted")
		to_world("<FONT size = 3><B>Mercenary Minor Victory!</B></FONT>")
		to_world("<B>[syndicate_name] operatives recovered the abandoned authentication disk but detonation of [station_name()] was averted.</B> Next time, don't lose the disk!")

	else if (!disk_rescued && !crew_evacuated)
		SSstatistics.set_field_details("round_end_result","halfwin - interrupted")
		to_world("<FONT size = 3><B>Neutral Victory</B></FONT>")
		to_world("<B>Round was mysteriously interrupted!</B>")

	..()
	return
