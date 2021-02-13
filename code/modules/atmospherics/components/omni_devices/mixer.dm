//--------------------------------------------
// Gas mixer - omni variant
//--------------------------------------------
/obj/machinery/atmospherics/omni/mixer
	name = "omni gas mixer"
	icon_state = "map_mixer"

	idle_power_usage = 150		//internal circuitry, friction losses and stuff
	power_rating = 15000			// 15000 W ~ 20 HP

	var/list/inputs = new()
	var/datum/omni_port/output
	var/max_output_pressure = MAX_OMNI_PRESSURE

	//setup tags for initial concentration values (must be decimal)
	var/tag_north_con
	var/tag_south_con
	var/tag_east_con
	var/tag_west_con

	var/max_flow_rate = ATMOS_DEFAULT_VOLUME_MIXER
	var/set_flow_rate = ATMOS_DEFAULT_VOLUME_MIXER

	var/list/mixing_inputs = list()
	build_icon_state = "omni_mixer"

/obj/machinery/atmospherics/omni/mixer/Initialize()
	. = ..()
	if(mapper_set())
		var/con = 0
		for(var/datum/omni_port/P in ports)
			switch(P.dir)
				if(NORTH)
					if(tag_north_con && tag_north == 1)
						P.concentration = tag_north_con
						con += max(0, tag_north_con)
				if(SOUTH)
					if(tag_south_con && tag_south == 1)
						P.concentration = tag_south_con
						con += max(0, tag_south_con)
				if(EAST)
					if(tag_east_con && tag_east == 1)
						P.concentration = tag_east_con
						con += max(0, tag_east_con)
				if(WEST)
					if(tag_west_con && tag_west == 1)
						P.concentration = tag_west_con
						con += max(0, tag_west_con)

	for(var/datum/omni_port/P in ports)
		P.air.volume = ATMOS_DEFAULT_VOLUME_MIXER

/obj/machinery/atmospherics/omni/mixer/Destroy()
	inputs.Cut()
	output = null
	. = ..()

/obj/machinery/atmospherics/omni/mixer/sort_ports()
	for(var/datum/omni_port/P in ports)
		if(P.update)
			if(output == P)
				output = null
			if(list_find(inputs, P))
				inputs -= P

			switch(P.mode)
				if(ATM_INPUT)
					inputs += P
				if(ATM_OUTPUT)
					output = P

	if(!mapper_set())
		for(var/datum/omni_port/P in inputs)
			P.concentration = 1 / max(1, inputs.len)

	if(output)
		output.air.volume = ATMOS_DEFAULT_VOLUME_MIXER * 0.75 * inputs.len
		output.concentration = 1

	rebuild_mixing_inputs()

/obj/machinery/atmospherics/omni/mixer/proc/mapper_set()
	return (tag_north_con || tag_south_con || tag_east_con || tag_west_con)

/obj/machinery/atmospherics/omni/mixer/error_check()
	if(!output || !inputs)
		return 1
	if(inputs.len < 2) //requires at least 2 inputs ~otherwise why are you using a mixer?
		return 1

	//concentration must add to 1
	var/total = 0
	for (var/datum/omni_port/P in inputs)
		total += P.concentration

	if (total != 1)
		return 1

	return 0

/obj/machinery/atmospherics/omni/mixer/Process()
	if(!..())
		return 0

	//Figure out the amount of moles to transfer
	var/transfer_moles = 0
	var/datum/gas_mixture/output_gas = output.air
	var/delta = between(0, (output_gas ? (max_output_pressure - output_gas.return_pressure()) : 0), max_output_pressure)
	var/transfer_moles_max = INFINITY

	for (var/datum/omni_port/P in inputs)
		transfer_moles += (set_flow_rate*P.concentration/P.air.volume)*P.air.total_moles
		transfer_moles_max = min(transfer_moles_max, calculate_transfer_moles(P.air, output.air, delta, (output && output.network && output.network.volume) ? output.network.volume : 0))
	transfer_moles = between(0, transfer_moles, transfer_moles_max)

	var/power_draw = -1
	if (transfer_moles > MINIMUM_MOLES_TO_FILTER)
		power_draw = mix_gas(src, mixing_inputs, output.air, transfer_moles, power_rating)

	if (power_draw >= 0)
		last_power_draw = power_draw
		use_power_oneoff(power_draw)

		for(var/datum/omni_port/P in inputs)
			if(P.concentration && P.network)
				P.network.update = 1

		if(output.network)
			output.network.update = 1

	return 1

/obj/machinery/atmospherics/omni/mixer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	usr.set_machine(src)

	var/list/data = new()

	data = build_uidata()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "omni_mixer.tmpl", "Omni Mixer Control", 360, 330)
		ui.set_initial_data(data)

		ui.open()

/obj/machinery/atmospherics/omni/mixer/proc/build_uidata()
	var/list/data = new()

	data["power"] = use_power
	data["config"] = configuring

	var/portData[0]
	for(var/datum/omni_port/P in ports)
		if(!configuring && P.mode == 0)
			continue

		var/input = 0
		var/output = 0
		switch(P.mode)
			if(ATM_INPUT)
				input = 1
			if(ATM_OUTPUT)
				output = 1

		portData[++portData.len] = list("dir" = dir_name(P.dir, capitalize = 1), \
										"concentration" = P.concentration, \
										"input" = input, \
										"output" = output, \
										"con_lock" = P.con_lock)

	if(portData.len)
		data["ports"] = portData
	if(output)
		data["set_flow_rate"] = round(set_flow_rate*10)		//because nanoui can't handle rounded decimals.
		data["last_flow_rate"] = round(last_flow_rate*10)

	return data

/obj/machinery/atmospherics/omni/mixer/Topic(href, href_list)
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
				set_flow_rate = between(0, new_flow_rate, max_flow_rate)
			if("switch_mode")
				switch_mode(dir_flag(href_list["dir"]), href_list["mode"])
			if("switch_con")
				change_concentration(dir_flag(href_list["dir"]))
			if("switch_conlock")
				con_lock(dir_flag(href_list["dir"]))

	update_icon()
	SSnano.update_uis(src)
	return

/obj/machinery/atmospherics/omni/mixer/proc/switch_mode(var/port = NORTH, var/mode = ATM_NONE)
	if(mode != ATM_INPUT && mode != ATM_OUTPUT)
		switch(mode)
			if("in")
				mode = ATM_INPUT
			if("out")
				mode = ATM_OUTPUT
			else
				mode = ATM_NONE

	for(var/datum/omni_port/P in ports)
		var/old_mode = P.mode
		if(P.dir == port)
			switch(mode)
				if(ATM_INPUT)
					if(P.mode == ATM_OUTPUT)
						return
					P.mode = mode
				if(ATM_OUTPUT)
					P.mode = mode
				if(ATM_NONE)
					if(P.mode == ATM_OUTPUT)
						return
					if(P.mode == ATM_INPUT && inputs.len > 2)
						P.mode = mode
		else if(P.mode == ATM_OUTPUT && mode == ATM_OUTPUT)
			P.mode = ATM_INPUT
		if(P.mode != old_mode)
			switch(P.mode)
				if(ATM_NONE)
					initialize_directions &= ~P.dir
					P.disconnect()
				else
					initialize_directions |= P.dir
					P.connect()
			P.update = 1

	update_ports()
	rebuild_mixing_inputs()

/obj/machinery/atmospherics/omni/mixer/proc/change_concentration(var/port = NORTH)
	tag_north_con = null
	tag_south_con = null
	tag_east_con = null
	tag_west_con = null

	var/old_con = 0
	var/non_locked = 0
	var/remain_con = 1

	for(var/datum/omni_port/P in inputs)
		if(P.dir == port)
			old_con = P.concentration
		else if(!P.con_lock)
			non_locked++
		else
			remain_con -= P.concentration

	//return if no adjustable ports
	if(non_locked < 1)
		return

	var/new_con = (input(usr,"Enter a new concentration (0-[round(remain_con * 100, 0.5)])%","Concentration control", min(remain_con, old_con)*100) as num) / 100

	//cap it between 0 and the max remaining concentration
	new_con = between(0, new_con, remain_con)

	//new_con = min(remain_con, new_con)

	//clamp remaining concentration so we don't go into negatives
	remain_con = max(0, remain_con - new_con)

	//distribute remaining concentration between unlocked ports evenly
	remain_con /= max(1, non_locked)

	for(var/datum/omni_port/P in inputs)
		if(P.dir == port)
			P.concentration = new_con
		else if(!P.con_lock)
			P.concentration = remain_con

	rebuild_mixing_inputs()

/obj/machinery/atmospherics/omni/mixer/proc/rebuild_mixing_inputs()
	mixing_inputs.Cut()
	for(var/datum/omni_port/P in inputs)
		mixing_inputs[P.air] = P.concentration

/obj/machinery/atmospherics/omni/mixer/proc/con_lock(var/port = NORTH)
	for(var/datum/omni_port/P in inputs)
		if(P.dir == port)
			P.con_lock = !P.con_lock