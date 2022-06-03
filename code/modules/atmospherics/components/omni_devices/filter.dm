// In theory these lists could be generated at runtime from values
// on the XGM gas datums - would need to have a consistent/constant
// id for the gasses but otherwise should allow for true omni filters.

GLOBAL_LIST_INIT(filter_gas_to_mode, list(    \
	"None" =           ATM_NONE,              \
	"Oxygen" =         ATM_O2,                \
	"Nitrogen" =       ATM_N2,                \
	"Carbon Dioxide" = ATM_CO2,               \
	"Phoron" =         ATM_P,                 \
	"Nitrous Oxide" =  ATM_N2O,               \
	"Hydrogen" =       ATM_H2,                \
	"Methyl Bromide" = ATM_CH3BR              \
))

GLOBAL_LIST_INIT(filter_mode_to_gas, list(    \
	"[ATM_O2]" =       "Oxygen",              \
	"[ATM_N2]" =       "Nitrogen",            \
	"[ATM_CO2]" =      "Carbon Dioxide",      \
	"[ATM_P]" =        "Phoron",              \
	"[ATM_N2O]" =      "Nitrous Oxide",       \
	"[ATM_H2]" =       "Hydrogen",            \
	"[ATM_CH3BR]" =    "Methyl Bromide"       \
))

GLOBAL_LIST_INIT(filter_mode_to_gas_id, list( \
	"[ATM_O2]" =       "[GAS_OXYGEN]",        \
	"[ATM_N2]" =       "[GAS_NITROGEN]",      \
	"[ATM_CO2]" =      "[GAS_CO2]",           \
	"[ATM_P]" =        "[GAS_PHORON]",        \
	"[ATM_N2O]" =      "[GAS_N2O]",           \
	"[ATM_H2]" =       "[GAS_HYDROGEN]",      \
	"[ATM_CH3BR]" =    "[GAS_METHYL_BROMIDE]" \
))

//--------------------------------------------
// Gas filter - omni variant
//--------------------------------------------
/obj/machinery/atmospherics/omni/filter
	name = "omni gas filter"
	icon_state = "map_filter"

	var/list/gas_filters = new()
	var/datum/omni_port/input
	var/datum/omni_port/output
	var/max_output_pressure = MAX_OMNI_PRESSURE

	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 15000			// 15000 W ~ 20 HP

	var/max_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_FILTER

	var/list/filtering_outputs = list()	//maps gasids to gas_mixtures
	build_icon_state = "omni_filter"

/obj/machinery/atmospherics/omni/filter/Initialize()
	. = ..()
	rebuild_filtering_list()
	for(var/datum/omni_port/P in ports)
		P.air.volume = ATMOS_DEFAULT_VOLUME_FILTER

/obj/machinery/atmospherics/omni/filter/Destroy()
	input = null
	output = null
	gas_filters.Cut()
	. = ..()

/obj/machinery/atmospherics/omni/filter/sort_ports()
	for(var/datum/omni_port/P in ports)
		if(P.update)
			if(output == P)
				output = null
			if(input == P)
				input = null
			if(P in gas_filters)
				gas_filters -= P

			P.air.volume = ATMOS_DEFAULT_VOLUME_FILTER
			switch(P.mode)
				if(ATM_INPUT)
					input = P
				if(ATM_OUTPUT)
					output = P
				if(ATM_GAS_MIN to ATM_GAS_MAX)
					gas_filters += P

/obj/machinery/atmospherics/omni/filter/error_check()
	if(!input || !output || !gas_filters)
		return 1
	if(gas_filters.len < 1) //requires at least 1 filter ~otherwise why are you using a filter?
		return 1

	return 0

/obj/machinery/atmospherics/omni/filter/Process()
	if(!..())
		return 0

	var/datum/gas_mixture/output_air = output.air	//BYOND doesn't like referencing "output.air.return_pressure()" so we need to make a direct reference
	var/datum/gas_mixture/input_air = input.air		// it's completely happy with them if they're in a loop though i.e. "P.air.return_pressure()"... *shrug*

	var/delta = clamp((output_air ? (max_output_pressure - output_air.return_pressure()) : 0), 0, max_output_pressure)
	var/transfer_moles_max = calculate_transfer_moles(input_air, output_air, delta, (output && output.network && output.network.volume) ? output.network.volume : 0)
	for(var/datum/omni_port/filter_output in gas_filters)
		delta = clamp((filter_output.air ? (max_output_pressure - filter_output.air.return_pressure()) : 0), 0, max_output_pressure)
		transfer_moles_max = min(transfer_moles_max, (calculate_transfer_moles(input_air, filter_output.air, delta, (filter_output && filter_output.network && filter_output.network.volume) ? filter_output.network.volume : 0)))

	//Figure out the amount of moles to transfer
	var/transfer_moles = clamp(((set_flow_rate/input_air.volume)*input_air.total_moles), 0, transfer_moles_max)

	var/power_draw = -1
	if (transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = filter_gas_multi(src, filtering_outputs, input_air, output_air, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

		if(input.network)
			input.network.update = 1
		if(output.network)
			output.network.update = 1
		for(var/datum/omni_port/P in gas_filters)
			if(P.network)
				P.network.update = 1

	return 1

/obj/machinery/atmospherics/omni/filter/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!user)
		if (ui)
			ui.close()
		return

	user.set_machine(src)

	var/list/data = new()

	data = build_uidata()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "omni_filter.tmpl", "Omni Filter Control", 330, 330)
		ui.set_initial_data(data)

		ui.open()

/obj/machinery/atmospherics/omni/filter/proc/build_uidata()
	var/list/data = new()

	data["power"] = use_power
	data["config"] = configuring

	var/portData[0]
	for(var/datum/omni_port/P in ports)
		if(!configuring && P.mode == 0)
			continue

		var/input = 0
		var/output = 0
		var/is_filter = 1
		var/f_type = null
		switch(P.mode)
			if(ATM_INPUT)
				input = 1
				is_filter = 0
			if(ATM_OUTPUT)
				output = 1
				is_filter = 0
			if(ATM_GAS_MIN to ATM_GAS_MAX)
				f_type = mode_send_switch(P.mode)

		portData[++portData.len] = list("dir" = dir_name(P.dir, capitalize = 1), \
										"input" = input, \
										"output" = output, \
										"filter" = is_filter, \
										"f_type" = f_type)

	if(portData.len)
		data["ports"] = portData
	if(output)
		data["set_flow_rate"] = round(set_flow_rate*10)		//because nanoui can't handle rounded decimals.
		data["last_flow_rate"] = round(last_flow_rate*10)

	return data

/obj/machinery/atmospherics/omni/filter/proc/mode_send_switch(var/mode = ATM_NONE)
	return GLOB.filter_mode_to_gas["[mode]"]

/obj/machinery/atmospherics/omni/filter/Topic(href, href_list)
	if(..()) return 1
	switch(href_list["command"])
		if("power")
			if(!configuring)
				update_use_power(!use_power)
			else
				update_use_power(POWER_USE_OFF)
		if("configure")
			configuring = !configuring
			if(configuring)
				update_use_power(POWER_USE_OFF)

	//only allows config changes when in configuring mode ~otherwise you'll get weird pressure stuff going on
	if(configuring && !use_power)
		switch(href_list["command"])
			if("set_flow_rate")
				var/new_flow_rate = input(usr,"Enter new flow rate limit (0-[max_flow_rate]L/s)","Flow Rate Control",set_flow_rate) as num
				set_flow_rate = clamp(new_flow_rate, 0, max_flow_rate)
			if("switch_mode")
				switch_mode(dir_flag(href_list["dir"]), mode_return_switch(href_list["mode"]))
			if("switch_filter")
				var/new_filter = input(usr,"Select filter mode:","Change filter",href_list["mode"]) in GLOB.filter_gas_to_mode
				switch_filter(dir_flag(href_list["dir"]), mode_return_switch(new_filter))

	update_icon()
	SSnano.update_uis(src)
	return

/obj/machinery/atmospherics/omni/filter/proc/mode_return_switch(var/mode)
	. = GLOB.filter_gas_to_mode[mode]
	if(!.)
		switch(mode)
			if("in")
				return ATM_INPUT
			if("out")
				return ATM_OUTPUT

/obj/machinery/atmospherics/omni/filter/proc/switch_filter(var/dir, var/mode)
	//check they aren't trying to disable the input or output ~this can only happen if they hack the cached tmpl file
	for(var/datum/omni_port/P in ports)
		if(P.dir == dir)
			if(P.mode == ATM_INPUT || P.mode == ATM_OUTPUT)
				return

	switch_mode(dir, mode)

/obj/machinery/atmospherics/omni/filter/proc/switch_mode(var/port, var/mode)
	if(mode == null || !port)
		return
	var/datum/omni_port/target_port = null
	var/list/other_ports = new()

	for(var/datum/omni_port/P in ports)
		if(P.dir == port)
			target_port = P
		else
			other_ports += P

	var/previous_mode = null
	if(target_port)
		previous_mode = target_port.mode
		target_port.mode = mode
		if(target_port.mode != previous_mode)
			handle_port_change(target_port)
			rebuild_filtering_list()
		else
			return
	else
		return

	for(var/datum/omni_port/P in other_ports)
		if(P.mode == mode)
			var/old_mode = P.mode
			P.mode = previous_mode
			if(P.mode != old_mode)
				handle_port_change(P)

	update_ports()

/obj/machinery/atmospherics/omni/filter/proc/rebuild_filtering_list()
	filtering_outputs.Cut()
	for(var/datum/omni_port/P in ports)
		var/gasid = GLOB.filter_mode_to_gas_id["[P.mode]"]
		if(gasid)
			filtering_outputs[gasid] = P.air

/obj/machinery/atmospherics/omni/filter/proc/handle_port_change(var/datum/omni_port/P)
	switch(P.mode)
		if(ATM_NONE)
			initialize_directions &= ~P.dir
			P.disconnect()
		else
			initialize_directions |= P.dir
			P.connect()
	P.update = 1