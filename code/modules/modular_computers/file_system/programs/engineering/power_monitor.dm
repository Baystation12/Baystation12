/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	nanomodule_path = /datum/nano_module/power_monitor/
	program_icon_state = "power_monitor"
	extended_desc = "This program connects to sensors to provide information about electrical systems"
	ui_header = "power_norm.gif"
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "power monitoring system"
	size = 9
	var/has_alert = 0

/datum/computer_file/program/power_monitor/process_tick()
	..()
	var/datum/nano_module/power_monitor/NMA = NM
	if(istype(NMA) && NMA.has_alarm())
		if(!has_alert)
			program_icon_state = "power_monitor_warn"
			ui_header = "power_warn.gif"
			update_computer_icon()
			has_alert = 1
	else
		if(has_alert)
			program_icon_state = "power_monitor"
			ui_header = "power_norm.gif"
			update_computer_icon()
			has_alert = 0

/datum/nano_module/power_monitor
	name = "Power monitor"
	var/list/grid_sensors
	var/active_sensor = null	//name_tag of the currently selected sensor

/datum/nano_module/power_monitor/New()
	..()
	refresh_sensors()

/datum/nano_module/power_monitor/Destroy()
	for(var/grid_sensor in grid_sensors)
		remove_sensor(grid_sensor, FALSE)
	grid_sensors = null
	. = ..()

// Checks whether there is an active alarm, if yes, returns 1, otherwise returns 0.
/datum/nano_module/power_monitor/proc/has_alarm()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0

// If PC is not null header template is loaded. Use PC.get_header_data() to get relevant nanoui data from it. All data entries begin with "PC_...."
// In future it may be expanded to other modular computer devices.
/datum/nano_module/power_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	var/list/sensors = list()
	// Focus: If it remains null if no sensor is selected and UI will display sensor list, otherwise it will display sensor reading.
	var/obj/machinery/power/sensor/focus = null

	// Build list of data from sensor readings.
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		sensors.Add(list(list(
		"name" = S.name_tag,
		"alarm" = S.check_grid_warning()
		)))
		if(S.name_tag == active_sensor)
			focus = S

	data["all_sensors"] = sensors
	if(focus)
		data["focus"] = focus.return_reading_data()

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "power_monitor.tmpl", "Power Monitoring Console", 800, 500, state = state)
		if(host.update_layout()) // This is necessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Refreshes list of active sensors kept on this computer.
/datum/nano_module/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	var/turf/T = get_turf(nano_host())
	if(!T) // Safety check
		return
	var/connected_z_levels = GetConnectedZlevels(T.z)
	for(var/obj/machinery/power/sensor/S in machines)
		if((S.long_range) || (S.loc.z in connected_z_levels)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
				warning("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
			else
				grid_sensors += S
				GLOB.destroyed_event.register(S, src, /datum/nano_module/power_monitor/proc/remove_sensor)

/datum/nano_module/power_monitor/proc/remove_sensor(var/removed_sensor, var/update_ui = TRUE)
	if(active_sensor == removed_sensor)
		active_sensor = null
		if(update_ui)
			GLOB.nanomanager.update_uis(src)
	grid_sensors -= removed_sensor
	GLOB.destroyed_event.unregister(removed_sensor, src, /datum/nano_module/power_monitor/proc/remove_sensor)

// Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/nano_module/power_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list["clear"] )
		active_sensor = null
		. = 1
	if( href_list["refresh"] )
		refresh_sensors()
		. = 1
	else if( href_list["setsensor"] )
		active_sensor = href_list["setsensor"]
		. = 1
