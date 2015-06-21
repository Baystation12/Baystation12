var/datum/antagonist/xenos/xenomorphs

/datum/antagonist/xenos
	id = MODE_XENOMORPH
	role_type = BE_ALIEN
	role_text = "Xenomorph"
	role_text_plural = "Xenomorphs"
	mob_path = /mob/living/carbon/alien/larva
	bantype = "Xenomorph"
	flags = ANTAG_OVERRIDE_MOB | ANTAG_RANDSPAWN | ANTAG_OVERRIDE_JOB | ANTAG_VOTABLE
	welcome_text = "Hiss! You are a larval alien. Hide and bide your time until you are ready to evolve."

	max_antags = 5
	max_antags_round = 8

	spawn_announcement = "Unidentified lifesigns detected coming aboard the station. Secure any exterior access, including ducting and ventilation."
	spawn_announcement_title = "Lifesign Alert"
	spawn_announcement_sound = 'sound/AI/aliens.ogg'
	spawn_announcement_delay = 400

/datum/antagonist/xenos/New(var/no_reference)
	..()
	if(!no_reference)
		xenomorphs = src

/datum/antagonist/xenos/Topic(href, href_list)
	if (..())
		return
	if(href_list["move_to_spawn"]) place_mob(locate(href_list["move_to_spawn"]))

/datum/antagonist/xenos/get_extra_panel_options(var/datum/mind/player)
	return "<a href='?src=\ref[src];move_to_spawn=\ref[player.current]'>\[move to vent\]</a>"

/datum/antagonist/xenos/attempt_random_spawn()
	if(config.aliens_allowed) ..()

/datum/antagonist/xenos/proc/get_vents()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in config.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent
	return vents

/datum/antagonist/xenos/create_objectives(var/datum/mind/player)
	if(!..())
		return
	player.objectives += new /datum/objective/survive()
	player.objectives += new /datum/objective/escape()

/datum/antagonist/xenos/place_all_mobs()
	var/list/vents = get_vents()
	for(var/datum/mind/player in current_antagonists)
		var/obj/machinery/atmospherics/unary/vent_pump/temp_vent = pick(vents)
		vents -= temp_vent
		player.current.loc = get_turf(temp_vent)

/datum/antagonist/xenos/place_mob(var/mob/living/player)
	player.loc = get_turf(pick(get_vents()))
