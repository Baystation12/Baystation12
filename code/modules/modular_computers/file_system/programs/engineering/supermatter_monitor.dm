#define SM_MONITOR_SCREEN_MAIN        "main"
#define SM_MONITOR_SCREEN_THRESHHOLDS "threshholds"


/datum/computer_file/program/supermatter_monitor
	filename = "supmon"
	filedesc = "Supermatter Monitoring"
	nanomodule_path = /datum/nano_module/program/supermatter_monitor
	program_icon_state = "smmon_0"
	program_key_state = "tech_key"
	program_menu_icon = "notice"
	extended_desc = "This program connects to specially calibrated supermatter sensors to provide information on the status of supermatter-based engines."
	ui_header = "smmon_0.gif"
	required_access = access_engine
	requires_ntnet = TRUE
	network_destination = "supermatter monitoring system"
	size = 5
	category = PROG_ENG
	var/last_status = 0

/datum/computer_file/program/supermatter_monitor/process_tick()
	..()
	var/datum/nano_module/program/supermatter_monitor/NMS = NM
	var/new_status = istype(NMS) ? NMS.get_status() : 0
	if(last_status != new_status)
		last_status = new_status
		ui_header = "smmon_[last_status].gif"
		program_icon_state = "smmon_[last_status]"
		update_computer_icon(FALSE)

/datum/nano_module/program/supermatter_monitor
	name = "Supermatter monitor"
	available_to_ai = TRUE
	var/list/supermatters
	var/obj/machinery/power/supermatter/active = null		// Currently selected supermatter crystal.
	var/screen = SM_MONITOR_SCREEN_MAIN // Which screen the monitor is currently on

/datum/nano_module/program/supermatter_monitor/Destroy()
	. = ..()
	active = null
	supermatters = null

/datum/nano_module/program/supermatter_monitor/New()
	..()
	refresh()

// Refreshes list of active supermatter crystals
/datum/nano_module/program/supermatter_monitor/proc/refresh()
	supermatters = list()
	var/valid_z_levels = GetConnectedZlevels(get_host_z())
	for(var/obj/machinery/power/supermatter/S in SSmachines.machinery)
		// Delaminating, not within coverage, not on a tile.
		if(S.grav_pulling || S.exploded || !(S.z in valid_z_levels) || !isturf(S.loc))
			continue
		supermatters.Add(S)

	if(!(active in supermatters))
		active = null
		screen = initial(screen)

/datum/nano_module/program/supermatter_monitor/proc/get_status()
	. = SUPERMATTER_INACTIVE
	for(var/obj/machinery/power/supermatter/S in supermatters)
		. = max(., S.get_status())

/datum/nano_module/program/supermatter_monitor/proc/process_data_output(skill, value)
	switch(skill)
		if(SKILL_UNSKILLED)
			return (0.6 + 0.8 * rand()) * value
		if(SKILL_BASIC)
			return (0.8 + 0.4 * rand()) * value
		else
			return value

/datum/nano_module/program/supermatter_monitor/proc/get_threshhold_color(threshhold, value)
	for (var/entry in active.threshholds)
		if (entry["name"] != threshhold)
			continue
		if (entry["min_h"] >= 0 && value <= entry["min_h"])
			return "bad"
		if (entry["min_l"] >= 0 && value <= entry["min_l"])
			return "average"
		if (entry["max_h"] >= 0 && value >= entry["max_h"])
			return "bad"
		if (entry["max_l"] >= 0 && value >= entry["max_l"])
			return "average"
	return "good"

/datum/nano_module/program/supermatter_monitor/proc/set_threshhold_value(threshhold, category, value)
	for (var/entry in active.threshholds)
		if (entry["name"] != threshhold)
			continue
		entry[category] = value

/datum/nano_module/program/supermatter_monitor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data(program)
	var/engine_skill = user.get_skill_value(SKILL_ENGINES)

	if(istype(active))
		var/turf/T = get_turf(active)
		if(!T)
			active = null
			screen = initial(screen)
			return
		var/datum/gas_mixture/air = T.return_air()
		if(!istype(air))
			active = null
			screen = initial(screen)
			return

		var/ambient_pressure = air.return_pressure()
		var/epr = active.get_epr()

		var/shutdown_phase = active.get_phase()
		if (active.shutdown_aborted)
			shutdown_phase = SPAN_BAD("ABORTING")
		else if ((active.cooldown_time + active.last_shutdown_time) > world.time)
			shutdown_phase = SPAN_BAD("COOLING DOWN")

		data["active"] = TRUE
		data["screen"] = screen
		data["threshholds"] = active.threshholds
		data["SM_integrity"] = min(process_data_output(engine_skill, active.get_integrity()), 100)
		data["SM_power"] = process_data_output(engine_skill, active.power)
		data["SM_power_label"] = get_threshhold_color(SUPERMATTER_DATA_EER, active.power)
		data["SM_ambienttemp"] = process_data_output(engine_skill, air.temperature)
		data["SM_ambienttemp_label"] = get_threshhold_color(SUPERMATTER_DATA_TEMPERATURE, air.temperature)
		data["SM_ambientpressure"] = process_data_output(engine_skill, ambient_pressure)
		data["SM_ambientpressure_label"] = get_threshhold_color(SUPERMATTER_DATA_PRESSURE, ambient_pressure)
		data["SM_EPR"] = process_data_output(engine_skill, epr)
		data["SM_EPR_label"] = get_threshhold_color(SUPERMATTER_DATA_EPR, epr)
		data["SM_shutdown_phase"] = shutdown_phase
		if(air.total_moles)
			data["SM_gas_O2"] = round(100*air.gas[GAS_OXYGEN]/air.total_moles,0.01)
			data["SM_gas_CO2"] = round(100*air.gas[GAS_CO2]/air.total_moles,0.01)
			data["SM_gas_N2"] = round(100*air.gas[GAS_NITROGEN]/air.total_moles,0.01)
			data["SM_gas_PH"] = round(100*air.gas[GAS_PHORON]/air.total_moles,0.01)
			data["SM_gas_N2O"] = round(100*air.gas[GAS_N2O]/air.total_moles,0.01)
			data["SM_gas_H2"] = round(100*air.gas[GAS_HYDROGEN]/air.total_moles,0.01)
		else
			data["SM_gas_O2"] = 0
			data["SM_gas_CO2"] = 0
			data["SM_gas_N2"] = 0
			data["SM_gas_PH"] = 0
			data["SM_gas_N2O"] = 0
			data["SM_gas_H2"] = 0
	else
		var/list/per_supermatter_data = list()
		for (var/obj/machinery/power/supermatter/supermatter as anything in supermatters)
			var/area/area = get_area(supermatter)
			if (!area)
				continue
			per_supermatter_data += list(list(
				"area_name" = area.name,
				"integrity" = process_data_output(engine_skill, supermatter.get_integrity()),
				"ref" = any2ref(supermatter)
			))
		data["supermatters"] = per_supermatter_data
		data["active"] = FALSE

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supermatter_monitor.tmpl", "Supermatter Monitoring", 600, 400, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/supermatter_monitor/Topic(href, list/href_list)
	. = ..()
	if (.)
		return
	if (href_list["clear"])
		active = null
		screen = initial(screen)
		return TOPIC_HANDLED
	if (href_list["refresh"])
		refresh()
		return TOPIC_HANDLED
	if (href_list["screen_threshholds"])
		screen = SM_MONITOR_SCREEN_THRESHHOLDS
		return TOPIC_HANDLED
	if (href_list["screen_main"])
		screen = SM_MONITOR_SCREEN_MAIN
		return TOPIC_HANDLED
	if (href_list["set_threshhold"])
		var/new_value = input(usr, "Select a new threshhold, or set to -1 to disable:", "Threshhold", href_list["value"]) as null | num
		if (!isnull(new_value))
			set_threshhold_value(href_list["threshhold"], href_list["category"], new_value)
		return TOPIC_HANDLED
	if (href_list["set"])
		var/obj/machinery/power/supermatter/supermatter = locate(href_list["set"])
		if (!(supermatter in supermatters))
			return TOPIC_NOACTION
		active = supermatter
		return TOPIC_HANDLED
	if (href_list["set"])
		var/obj/machinery/power/supermatter/supermatter = locate(href_list["set"])
		if (!(supermatter in supermatters))
			return TOPIC_NOACTION
		active = supermatter
		return TOPIC_HANDLED
