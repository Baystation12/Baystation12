/datum/nano_module/crew_monitor
	name = "Crew monitor"

/datum/nano_module/crew_monitor/Topic(href, href_list)
	if(..()) return 1
	var/turf/T = get_turf(nano_host())	// TODO: Allow setting any config.contact_levels from the interface.
	if (!T || !(T.z in config.player_levels))
		usr << "<span class='warning'>Unable to establish a connection</span>: You're too far away from the station!"
		return 0
	if(href_list["track"])
		if(usr.isMobAI())
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list["track"]) in mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
		return 1

/datum/nano_module/crew_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/data[0]
	var/turf/T = get_turf(nano_host())

	data["isAI"] = user.isMobAI()
	data["crewmembers"] = crew_repository.health_data(T)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "crew_monitor.tmpl", "Crew Monitoring Computer", 900, 800, state = state)

		// adding a template with the key "mapContent" enables the map ui functionality
		ui.add_template("mapContent", "crew_monitor_map_content.tmpl")
		// adding a template with the key "mapHeader" replaces the map header content
		ui.add_template("mapHeader", "crew_monitor_map_header.tmpl")

		ui.set_initial_data(data)
		ui.open()

		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update(1)

/datum/nano_module/crew_monitor/proc/scan()
	for(var/mob/living/carbon/human/H in mob_list)
		if(istype(H.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/C = H.w_uniform
			if (C.has_sensor)
				tracked |= C
	return 1
