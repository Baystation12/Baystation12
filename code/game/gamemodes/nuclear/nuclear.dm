/*
	MERCENARY ROUNDTYPE
*/

var/list/nuke_disks = list()

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

//checks if L has a nuke disk on their person
/datum/game_mode/nuclear/proc/check_mob(mob/living/L)
	for(var/obj/item/disk/nuclear/N in nuke_disks)
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
	var/crew_evacuated = (evacuation_controller.has_evacuated())

	if(!disk_rescued &&  station_was_nuked && !syndies_didnt_escape)
		to_world("<FONT size = 3><B>Mercenary Major Victory!</B></FONT>")
		to_world("<B>[syndicate_name()] operatives have destroyed [station_name()]!</B>")

	else if (!disk_rescued &&  station_was_nuked && syndies_didnt_escape)
		to_world("<FONT size = 3><B>Total Annihilation</B></FONT>")
		to_world("<B>[syndicate_name()] operatives destroyed [station_name()] but did not leave the area in time and got caught in the explosion.</B> Next time, don't lose the disk!")

	else if (!disk_rescued && !station_was_nuked &&  nuke_off_station && !syndies_didnt_escape)
		to_world("<FONT size = 3><B>Crew Minor Victory</B></FONT>")
		to_world("<B>[syndicate_name()] operatives secured the authentication disk but blew up something that wasn't [station_name()].</B> Next time, don't lose the disk!")

	else if (!disk_rescued && !station_was_nuked &&  nuke_off_station && syndies_didnt_escape)
		to_world("<FONT size = 3><B>[syndicate_name()] operatives have earned Darwin Award!</B></FONT>")
		to_world("<B>[syndicate_name()] operatives blew up something that wasn't [station_name()] and got caught in the explosion.</B> Next time, don't lose the disk!")

	else if (disk_rescued && GLOB.mercs.antags_are_dead())
		to_world("<FONT size = 3><B>Crew Major Victory!</B></FONT>")
		to_world("<B>The Research Staff has saved the disc and killed the [syndicate_name()] Operatives</B>")

	else if ( disk_rescued                                        )
		to_world("<FONT size = 3><B>Crew Major Victory</B></FONT>")
		to_world("<B>The Research Staff has saved the disc and stopped the [syndicate_name()] Operatives!</B>")

	else if (!disk_rescued && GLOB.mercs.antags_are_dead())
		to_world("<FONT size = 3><B>Mercenary Minor Victory!</B></FONT>")
		to_world("<B>The Research Staff failed to secure the authentication disk but did manage to kill most of the [syndicate_name()] Operatives!</B>")

	else if (!disk_rescued && crew_evacuated)
		to_world("<FONT size = 3><B>Mercenary Minor Victory!</B></FONT>")
		to_world("<B>[syndicate_name()] operatives recovered the abandoned authentication disk but detonation of [station_name()] was averted.</B> Next time, don't lose the disk!")

	else if (!disk_rescued && !crew_evacuated)
		to_world("<FONT size = 3><B>Neutral Victory</B></FONT>")
		to_world("<B>Round was mysteriously interrupted!</B>")

	..()
	return
