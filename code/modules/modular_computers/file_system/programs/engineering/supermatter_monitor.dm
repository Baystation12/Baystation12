/datum/computer_file/program/supermatter_monitor
	filename = "supmon"
	filedesc = "Supermatter Monitoring"
	nanomodule_path = /datum/nano_module/supermatter_monitor/
	program_icon_state = "smmon_0"
	extended_desc = "This program connects to specially calibrated supermatter sensors to provide information on the status of supermatter-based reactors."
	ui_header = "smmon_0.gif"
	required_access = access_engine
	requires_ntnet = 1
	network_destination = "supermatter monitoring system"
	size = 5
	var/last_status = 0

/datum/computer_file/program/supermatter_monitor/process_tick()
	..()
	var/datum/nano_module/supermatter_monitor/NMS = NM
	var/new_status = istype(NMS) ? NMS.get_status() : 0
	if(last_status != new_status)
		last_status = new_status
		ui_header = "smmon_[last_status].gif"
		program_icon_state = "smmon_[last_status]"
		if(istype(computer))
			computer.update_icon()

/datum/nano_module/supermatter_monitor
	name = "Supermatter monitor"
	var/list/supermatters
	var/obj/machinery/power/supermatter/active = null		// Currently selected supermatter crystal.

/datum/nano_module/supermatter_monitor/Destroy()
	. = ..()
	active = null
	supermatters = null

/datum/nano_module/supermatter_monitor/New()
	..()
	refresh()

// Refreshes list of active supermatter crystals
/datum/nano_module/supermatter_monitor/proc/refresh()
	supermatters = list()
	var/turf/T = get_turf(nano_host())
	if(!T)
		return
	var/valid_z_levels = (GetConnectedZlevels(T.z) & using_map.station_levels)
	for(var/obj/machinery/power/supermatter/S in machines)
		// Delaminating, not within coverage, not on a tile.
		if(S.grav_pulling || S.exploded || !(S.z in valid_z_levels) || !istype(S.loc, /turf/))
			continue
		supermatters.Add(S)

	if(!(active in supermatters))
		active = null

/datum/nano_module/supermatter_monitor/proc/get_status()
	. = SUPERMATTER_INACTIVE
	for(var/obj/machinery/power/supermatter/S in supermatters)
		. = max(., S.get_status())

/datum/nano_module/supermatter_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	if(istype(active))
		var/turf/T = get_turf(active)
		if(!T)
			active = null
			return
		var/datum/gas_mixture/air = T.return_air()
		if(!istype(air))
			active = null
			return

		data["active"] = 1
		data["SM_integrity"] = active.get_integrity()
		data["SM_power"] = active.power
		data["SM_ambienttemp"] = air.temperature
		data["SM_ambientpressure"] = air.return_pressure()
		data["SM_EPR"] = round((air.total_moles / air.group_multiplier) / 23.1, 0.01)
		if(air.total_moles)
			data["SM_gas_O2"] = round(100*air.gas["oxygen"]/air.total_moles,0.01)
			data["SM_gas_CO2"] = round(100*air.gas["carbon_dioxide"]/air.total_moles,0.01)
			data["SM_gas_N2"] = round(100*air.gas["nitrogen"]/air.total_moles,0.01)
			data["SM_gas_PH"] = round(100*air.gas["phoron"]/air.total_moles,0.01)
			data["SM_gas_N2O"] = round(100*air.gas["sleeping_agent"]/air.total_moles,0.01)
		else
			data["SM_gas_O2"] = 0
			data["SM_gas_CO2"] = 0
			data["SM_gas_N2"] = 0
			data["SM_gas_PH"] = 0
			data["SM_gas_N2O"] = 0
	else
		var/list/SMS = list()
		for(var/obj/machinery/power/supermatter/S in supermatters)
			var/area/A = get_area(S)
			if(!A)
				continue

			SMS.Add(list(list(
			"area_name" = A.name,
			"integrity" = S.get_integrity(),
			"uid" = S.uid
			)))

		data["active"] = 0
		data["supermatters"] = SMS

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supermatter_monitor.tmpl", "Supermatter Monitoring", 600, 400, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/supermatter_monitor/Topic(href, href_list)
	if(..())
		return 1
	if( href_list["clear"] )
		active = null
		return 1
	if( href_list["refresh"] )
		refresh()
		return 1
	if( href_list["set"] )
		var/newuid = text2num(href_list["set"])
		for(var/obj/machinery/power/supermatter/S in supermatters)
			if(S.uid == newuid)
				active = S
		return 1