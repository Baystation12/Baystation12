// POWERNET SENSOR MONITORING CONSOLE
//
// Last Change 31.12.2014 by Atlantis
//
// Connects to powernet sensors and loads data from them. Shows this data to the user.
// Newly supports NanoUI.


/obj/machinery/computer/power_monitor
	name = "Power Monitoring Console"
	desc = "Computer designed to remotely monitor power levels around the station"
	icon = 'icons/obj/computer.dmi'
	icon_state = "power"

	//computer stuff
	density = 1
	anchored = 1.0
	circuit = /obj/item/weapon/circuitboard/powermonitor
	var/list/grid_sensors
	var/alerting = 0
	var/active_sensor = null	//name_tag of the currently selected sensor
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300

// Proc: process()
// Parameters: None
// Description: Checks the sensors for alerts. If change (alerts cleared or detected) occurs, calls for icon update.
/obj/machinery/computer/power_monitor/process()
	var/alert = check_warnings()
	if(alert != alerting)
		alerting = !alerting
		update_icon()

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this computer according to current status.
/obj/machinery/computer/power_monitor/update_icon()
	if(stat & BROKEN)
		icon_state = "powerb"
		return
	if(stat & NOPOWER)
		icon_state = "power0"
		return
	if(alerting)
		icon_state = "power_alert"
		return
	icon_state = "power"

// Proc: New()
// Parameters: None
// Description: On creation automatically connects to active sensors. This is delayed to ensure sensors already exist.
/obj/machinery/computer/power_monitor/New()
	..()
	spawn(50)
		refresh_sensors()

// Proc: refresh_sensors()
// Parameters: None
// Description: Refreshes list of active sensors kept on this computer.
/obj/machinery/computer/power_monitor/proc/refresh_sensors()
	grid_sensors = list()
	for(var/obj/machinery/power/sensor/S in machines)
		if((S.loc.z == src.loc.z) || (S.long_range)) // Consoles have range on their Z-Level. Sensors with long_range var will work between Z levels.
			if(S.name_tag == "#UNKN#") // Default name. Shouldn't happen!
				warning("Powernet sensor with unset ID Tag! [S.x]X [S.y]Y [S.z]Z")
			else
				grid_sensors += S

// Proc: attack_hand()
// Parameters: None
// Description: On user click opens the UI of this computer.
/obj/machinery/computer/power_monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

// Proc: Topic()
// Parameters: 2 (href, href_list - allows us to process UI clicks)
// Description: Allows us to process UI clicks, which are relayed in form of hrefs.
/obj/machinery/computer/power_monitor/Topic(href, href_list)
	..()
	if( href_list["clear"] )
		active_sensor = null
	else if( href_list["setsensor"] )
		active_sensor = href_list["setsensor"]

// Proc: check_warnings()
// Parameters: None
// Description: Verifies if any warnings were registered by connected sensors.
/obj/machinery/computer/power_monitor/proc/check_warnings()
	for(var/obj/machinery/power/sensor/S in grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0

// Proc: ui_interact()
// Parameters: 4 (standard NanoUI parameters)
// Description: Uses dark magic to operate the NanoUI of this computer.
/obj/machinery/computer/power_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
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

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "power_monitor.tmpl", "Power Monitoring Console", 800, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)