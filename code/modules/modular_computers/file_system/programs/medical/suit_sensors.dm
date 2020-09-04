/datum/computer_file/program/suit_sensors
	filename = "sensormonitor"
	filedesc = "Suit Sensors Monitoring"
	nanomodule_path = /datum/nano_module/crew_monitor
	program_icon_state = "crew"
	var/camera_icon_state = "cameras"
	extended_desc = "This program connects to life signs monitoring system to provide basic information on crew health."
	required_access = access_medical
	requires_ntnet = 1
	network_destination = "crew lifesigns monitoring system"
	size = 11

/datum/computer_file/program/suit_sensors/process_tick()
	..()
	update_icon_state()




/datum/nano_module/crew_monitor
	name = "Crew monitor"
	var/faction_name
	var/datum/faction/my_faction

/datum/nano_module/crew_monitor/New()
	. = ..()
	my_faction = GLOB.factions_by_name[faction_name]

/datum/nano_module/crew_monitor/Topic(href, href_list)
	if(..()) return 1

	if(href_list["track"])
		if(isAI(usr))
			var/mob/living/silicon/ai/AI = usr
			var/mob/living/carbon/human/H = locate(href_list["track"]) in GLOB.mob_list
			if(hassensorlevel(H, SUIT_SENSOR_TRACKING))
				AI.ai_actual_track(H)
		return 1

	if(href_list["view_cam"])
		var/mob/living/carbon/human/H = locate(href_list["view_cam"]) in GLOB.mob_list
		view_camera(usr, H)

	if(href_list["stop_cam"])
		cancel_camera()

	//if(href_list["close"])

/datum/nano_module/crew_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data["isAI"] = isAI(user)
	data["follow_mob"] = follow_mob ? TRUE : FALSE
	data["crewmembers"] = list()
	if(my_faction)
		data["crewmembers"] += my_faction.crew_repo.health_data()//crew_repository.health_data(z_level)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "crew_monitor.tmpl", "Crew Monitoring Computer", 600, 600, state = state)

		// adding a template with the key "mapContent" enables the map ui functionality
		ui.add_template("mapContent", "crew_monitor_map_content.tmpl")
		// adding a template with the key "mapHeader" replaces the map header content
		ui.add_template("mapHeader", "crew_monitor_map_header.tmpl")

		ui.ref = src
		apply_styling(ui)

		ui.set_initial_data(data)
		ui.open()

		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update(1)

//override this in children
/datum/nano_module/crew_monitor/proc/apply_styling(datum/nanoui/ui)
