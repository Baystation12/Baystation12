/datum/computer_file/program/atmos_control
	filename = "atmoscontrol"
	filedesc = "Atmosphere Control"
	nanomodule_path = /datum/nano_module/atmos_control
	program_icon_state = "atmos_control"
	program_key_state = "atmos_key"
	program_menu_icon = "shuffle"
	extended_desc = "This program allows remote control of air alarms. This program can not be run on tablet computers."
	required_access = access_atmospherics
	requires_ntnet = TRUE
	network_destination = "atmospheric control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_LAPTOP | PROGRAM_CONSOLE
	category = PROG_ENG
	size = 17

/datum/nano_module/atmos_control
	name = "Atmospherics Control"
	var/obj/access = new()
	var/emagged = FALSE
	var/ui_ref
	var/list/monitored_alarms = list()

/datum/nano_module/atmos_control/New(atmos_computer, list/req_access, monitored_alarm_ids)
	..()

	if(istype(req_access))
		access.req_access = req_access
	else if(req_access)
		log_debug("\The [src] was given an unexpected req_access: [req_access]")

	if(monitored_alarm_ids)
		for(var/obj/machinery/alarm/alarm as anything in SSmachines.get_machinery_of_type(/obj/machinery/alarm))
			if(alarm.alarm_id && (alarm.alarm_id in monitored_alarm_ids))
				monitored_alarms += alarm
		// machines may not yet be ordered at this point
		monitored_alarms = dd_sortedObjectList(monitored_alarms)

/datum/nano_module/atmos_control/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["alarm"])
		if(ui_ref)
			var/obj/machinery/alarm/alarm = locate(href_list["alarm"]) in (length(monitored_alarms) ? monitored_alarms : SSmachines.machinery)
			if(alarm)
				var/datum/topic_state/TS = generate_state(alarm)
				alarm.ui_interact(usr, master_ui = ui_ref, state = TS)
		return 1

/datum/nano_module/atmos_control/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, master_ui = null, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/alarms[0]
	var/alarmsAlert[0]
	var/alarmsDanger[0]

	// TODO: Move these to a cache, similar to cameras
	for(var/obj/machinery/alarm/alarm in (length(monitored_alarms) ? monitored_alarms : SSmachines.machinery))
		var/Z = get_host_z()
		if ((!length(monitored_alarms)) && (!Z || !AreConnectedZLevels(Z, alarm.z)))
			continue
		var/danger_level = max(alarm.danger_level, alarm.alarm_area.atmosalm)
		if(danger_level == 2)
			alarmsAlert[LIST_PRE_INC(alarmsAlert)] = list("name" = sanitize(alarm.name), "ref"= "\ref[alarm]", "danger" = danger_level)
		else if(danger_level == 1)
			alarmsDanger[LIST_PRE_INC(alarmsDanger)] = list("name" = sanitize(alarm.name), "ref"= "\ref[alarm]", "danger" = danger_level)
		else
			alarms[LIST_PRE_INC(alarms)] = list("name" = sanitize(alarm.name), "ref"= "\ref[alarm]", "danger" = danger_level)

	data["alarms"] = sortByKey(alarms, "name")
	data["alarmsAlert"] = sortByKey(alarmsAlert, "name")
	data["alarmsDanger"] = sortByKey(alarmsDanger, "name")

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "atmos_control.tmpl", src.name, 625, 625, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
	ui_ref = ui

/datum/nano_module/atmos_control/proc/generate_state(air_alarm)
	var/datum/topic_state/air_alarm/state = new()
	state.atmos_control = src
	state.air_alarm = air_alarm
	return state

/datum/topic_state/air_alarm
	var/datum/nano_module/atmos_control/atmos_control	= null
	var/obj/machinery/alarm/air_alarm					= null

/datum/topic_state/air_alarm/can_use_topic(src_object, mob/user)
	if(alarm_has_access(user))
		return STATUS_INTERACTIVE
	return STATUS_UPDATE

/datum/topic_state/air_alarm/href_list(mob/user)
	var/list/extra_href = list()
	extra_href["remote_connection"] = 1
	extra_href["remote_access"] = alarm_has_access(user)

	return extra_href

/datum/topic_state/air_alarm/proc/alarm_has_access(mob/user)
	return user && (isAI(user) || atmos_control.access.allowed(user) || atmos_control.emagged || air_alarm.rcon_setting == RCON_YES || (air_alarm.alarm_area.atmosalm && air_alarm.rcon_setting == RCON_AUTO))
