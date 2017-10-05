/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitoring"
	nanomodule_path = /datum/nano_module/alarm_monitor/engineering
	ui_header = "alarm_green.gif"
	program_icon_state = "alert-green"
	program_menu_icon = "alert"
	extended_desc = "This program provides visual interface for the alarm system."
	requires_ntnet = 1
	network_destination = "alarm monitoring network"
	size = 5
	var/has_alert = 0

/datum/computer_file/program/alarm_monitor/process_tick()
	..()
	var/datum/nano_module/alarm_monitor/NMA = NM
	if(istype(NMA) && NMA.has_major_alarms())
		if(!has_alert)
			program_icon_state = "alert-red"
			ui_header = "alarm_red.gif"
			update_computer_icon()
			has_alert = 1
	else
		if(has_alert)
			program_icon_state = "alert-green"
			ui_header = "alarm_green.gif"
			update_computer_icon()
			has_alert = 0
	return 1

/datum/nano_module/alarm_monitor
	name = "Alarm monitor"
	var/list_cameras = 0						// Whether or not to list camera references. A future goal would be to merge this with the enginering/security camera console. Currently really only for AI-use.
	var/list/datum/alarm_handler/alarm_handlers // The particular list of alarm handlers this alarm monitor should present to the user.
	available_to_ai = FALSE

/datum/nano_module/alarm_monitor/New()
	..()
	alarm_handlers = list()

/datum/nano_module/alarm_monitor/all
	available_to_ai = TRUE

/datum/nano_module/alarm_monitor/all/New()
	..()
	alarm_handlers = alarm_manager.all_handlers

/datum/nano_module/alarm_monitor/engineering/New()
	..()
	alarm_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, power_alarm)

/datum/nano_module/alarm_monitor/security/New()
	..()
	alarm_handlers = list(camera_alarm, motion_alarm)

/datum/nano_module/alarm_monitor/proc/register_alarm(var/object, var/procName)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.register_alarm(object, procName)

/datum/nano_module/alarm_monitor/proc/unregister_alarm(var/object)
	for(var/datum/alarm_handler/AH in alarm_handlers)
		AH.unregister_alarm(object)

/datum/nano_module/alarm_monitor/proc/all_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.alarms

	return all_alarms

/datum/nano_module/alarm_monitor/proc/major_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.major_alarms()

	return all_alarms

// Modified version of above proc that uses slightly less resources, returns 1 if there is a major alarm, 0 otherwise.
/datum/nano_module/alarm_monitor/proc/has_major_alarms()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		if(AH.has_major_alarms())
			return 1

	return 0

/datum/nano_module/alarm_monitor/proc/minor_alarms()
	var/list/all_alarms = new()
	for(var/datum/alarm_handler/AH in alarm_handlers)
		all_alarms += AH.minor_alarms()

	return all_alarms

/datum/nano_module/alarm_monitor/Topic(ref, href_list)
	if(..())
		return 1
	if(href_list["switchTo"])
		var/obj/machinery/camera/C = locate(href_list["switchTo"]) in cameranet.cameras
		if(!C)
			return

		usr.switch_to_camera(C)
		return 1

/datum/nano_module/alarm_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	var/categories[0]
	for(var/datum/alarm_handler/AH in alarm_handlers)
		categories[++categories.len] = list("category" = AH.category, "alarms" = list())
		for(var/datum/alarm/A in AH.major_alarms())
			var/cameras[0]
			var/lost_sources[0]

			if(isAI(user))
				for(var/obj/machinery/camera/C in A.cameras())
					cameras[++cameras.len] = C.nano_structure()
			for(var/datum/alarm_source/AS in A.sources)
				if(!AS.source)
					lost_sources[++lost_sources.len] = AS.source_name

			categories[categories.len]["alarms"] += list(list(
					"name" = sanitize(A.alarm_name()),
					"origin_lost" = A.origin == null,
					"has_cameras" = cameras.len,
					"cameras" = cameras,
					"lost_sources" = lost_sources.len ? sanitize(english_list(lost_sources, nothing_text = "", and_text = ", ")) : ""))
	data["categories"] = categories

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "alarm_monitor.tmpl", "Alarm Monitoring Console", 800, 800, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
