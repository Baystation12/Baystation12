/datum/computer_file/program/ship_sensors
	filename = "ssensors"
	filedesc = "Ship Sensor Control"
	program_icon_state = "teleport"
	nanomodule_path = /datum/nano_module/ship_sensors
	extended_desc = "Used to control ship sensor arrays."
	required_access = access_heads
	requires_ntnet = 1
	size = 19
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	network_destination = "sensor array"

/datum/nano_module/ship_sensors
	name = "Ship Sensor Control"
	available_to_ai = TRUE
	var/list/sensors = list()
	var/show_map = FALSE

/datum/nano_module/ship_sensors/proc/get_sensors()
	var/list/sensors = list()
	for(var/obj/machinery/power/shipsensors/S in GLOB.machines)
		if(S.z in GetConnectedZlevels(host_z()))
			sensors.Add(S)
	return sensors

/datum/nano_module/ship_sensors/proc/host_z()
	var/atom/movable/nanohost = nano_host()
	if(istype(nanohost))
		return nanohost.z
	return 0

/datum/nano_module/ship_sensors/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/readings = list()

	if(show_map)
		var/obj/effect/overmap/ship/linked = map_sectors["[host_z()]"]
		user.machine = nano_host()
		user.reset_view(linked)

	for(var/obj/machinery/power/shipsensors/S in get_sensors())
		var/status
		if(S.health <= 0)
			status = "Not Responding"
		else if (!S.has_power())
			status = "No Power"
		else if (!S.in_vacuum())
			status = "Vacuum Seal Broken"
		else
			status = "Functional"

		if(!status)
			continue
		readings.Add(list(list(
			"uid" = S.uid,
			"status" = status,
			"enabled" = S.enabled,
			"range" = S.range,
			"powerusage" = get_wattage(S.power_usage())
		)))
	data["readings"] = readings
	data["viewing"] = show_map

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ssensors.tmpl", name, 500, 400, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/ship_sensors/check_eye(var/mob/user as mob)
	if(!show_map)
		return -1
	return 0

/datum/nano_module/ship_sensors/Topic(href, href_list, state)
	if(..())
		return 1
	var/obj/effect/overmap/ship/linked = map_sectors["[host_z()]"]
	if (!linked)
		return
	if(href_list["toggle_view"])
		show_map = !show_map
		return 1

	else if(href_list["toggle_power"])
		for(var/obj/machinery/power/shipsensors/S in GLOB.machines)
			if(S.uid == text2num(href_list["toggle_power"]))
				S.toggle()
		return 1

	else if(href_list["set_range"])
		var/new_range = input("Enter new sensor range.") as null|num
		if(!new_range)
			return
		new_range = between(1, new_range, world.view)
		for(var/obj/machinery/power/shipsensors/S in GLOB.machines)
			if(S.uid == text2num(href_list["set_range"]))
				S.range = new_range
				S.update_icon()
		return 1