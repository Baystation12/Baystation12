/obj/nano_module/crew_monitor
	name = "Crew monitor"

/obj/nano_module/crew_monitor/Topic(href, href_list)
	if(..()) return 1
	var/turf/T = get_turf(src)
	if (!T || !(T.z in config.player_levels))
		usr << "<span class='warning'>Unable to establish a connection<span>: You're too far away from the station!"
		return 0
	if(href_list["close"] )
		var/mob/user = usr
		var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, "main")
		usr.unset_machine()
		ui.close()
		return 0
	if(href_list["update"])
		src.updateDialog()
		return 1
	if(href_list["track"])
		if(usr.isMobAI())
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list["track"]) in mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
		return 1

/obj/nano_module/crew_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/data[0]
	var/turf/T = get_turf(src)

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

	return 1
