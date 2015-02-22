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
	var/alerting = 0
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300
	var/obj/nano_module/power_monitor/power_monitor

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
		power_monitor = new(src)

// Proc: attack_hand()
// Parameters: None
// Description: On user click opens the UI of this computer.
/obj/machinery/computer/power_monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

// Proc: ui_interact()
// Parameters: 4 (standard NanoUI parameters)
// Description: Uses dark magic to operate the NanoUI of this computer.
/obj/machinery/computer/power_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	power_monitor.ui_interact(user, ui_key, ui, force_open)


// Proc: check_warnings()
// Parameters: None
// Description: Verifies if any warnings were registered by connected sensors.
/obj/machinery/computer/power_monitor/proc/check_warnings()
	for(var/obj/machinery/power/sensor/S in power_monitor.grid_sensors)
		if(S.check_grid_warning())
			return 1
	return 0
