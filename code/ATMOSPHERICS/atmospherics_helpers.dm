//Generalized gas pumping proc.
//Moves gas from one gas_mixture to another and returns the amount of power needed (assuming 1 second), or -1 if no gas was pumped.
//transfer_moles - Limits the amount of moles to transfer. The actual amount of gas moved may also be limited by available_power, if given.
//available_power - the maximum amount of power that may be used when moving gas. If null then the transfer is not limited by power, however power will still be used!

/obj/machinery/atmospherics/var/last_flow_rate = 0	//Can't return multiple values, unfortunately...

/obj/machinery/atmospherics/proc/pump_gas(var/datum/gas_mixture/source, var/datum/gas_mixture/sink, var/transfer_moles = null, var/available_power = null)
	if (source.total_moles < MINUMUM_MOLES_TO_PUMP)
		return -1
	
	if (!transfer_moles)
		transfer_moles = source.total_moles
	
	//Calculate the amount of energy required and limit transfer_moles based on available power
	var/specific_power = calculate_specific_power(source, sink)/ATMOS_PUMP_EFFICIENCY //this has to be calculated before we modify any gas mixtures
	if (available_power && specific_power > 0)
		transfer_moles = min(transfer_moles, available_power / specific_power)
	
	if (transfer_moles < MINUMUM_MOLES_TO_PUMP)
		return -1
	
	last_flow_rate = (transfer_moles/source.total_moles)*source.volume	//group_multiplier gets divided out here
	
	var/datum/gas_mixture/removed = source.remove(transfer_moles)
	if (isnull(removed)) //not sure why this would happen, but it does at the very beginning of the game
		return -1
	
	var/power_draw = specific_power*transfer_moles
	if (power_draw > 0)
		removed.add_thermal_energy(power_draw)	//1st law - energy is conserved
	
	sink.merge(removed)
	
	return power_draw

//Generalized gas filtering proc.
//Filters the gasses specified by filtering from one gas_mixture to another and returns the amount of power needed (assuming 1 second), or -1 if no gas was filtered.
//filtering - A list of gasids to be filtered from source
//total_transfer_moles - Limits the amount of moles to filter. The actual amount of gas filtered may also be limited by available_power, if given.
//available_power - the maximum amount of power that may be used when filtering gas. If null then the filtering is not limited by power, however power will still be used!
/obj/machinery/atmospherics/proc/filter_gas(var/list/filtering, var/datum/gas_mixture/source, var/datum/gas_mixture/sink, var/total_transfer_moles = null, var/available_power = null)
	if (source.total_moles < MINUMUM_MOLES_TO_FILTER)
		return -1

	filtering &= source.gas		//only filter gasses that are actually there.
	
	//Filter it
	var/total_specific_power = 0		//the power required to remove one mole of filterable gas
	var/total_filterable_moles = 0
	var/list/specific_power_gas = list()
	for (var/g in filtering)
		if (source.gas[g] < MINUMUM_MOLES_TO_FILTER)
			continue
	
		var/specific_power = calculate_specific_power_gas(g, source, sink)/ATMOS_FILTER_EFFICIENCY
		specific_power_gas[g] = specific_power
		total_specific_power += specific_power
		total_filterable_moles += source.gas[g]
	
	if (total_filterable_moles < MINUMUM_MOLES_TO_FILTER)
		return -1
	
	//Figure out how much of each gas to filter
	if (!total_transfer_moles)
		total_transfer_moles = total_filterable_moles
	else
		total_transfer_moles = min(total_transfer_moles, total_filterable_moles)
	
	//limit transfer_moles based on available power
	if (available_power && total_specific_power > 0)
		total_transfer_moles = min(total_transfer_moles, available_power/total_specific_power)
	
	if (total_transfer_moles < MINUMUM_MOLES_TO_FILTER)
		return -1
	
	var/power_draw = 0
	last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume	//group_multiplier gets divided out here
	for (var/g in filtering)
		var/transfer_moles = source.gas[g]
		//filter gas in proportion to the mole ratio
		transfer_moles = min(transfer_moles, total_transfer_moles*(source.gas[g]/total_filterable_moles))
		
		source.gas[g] -= transfer_moles
		sink.gas[g] += transfer_moles		//do we need to check if g is in sink.gas first?
		power_draw += specific_power_gas[g]*transfer_moles
	
	if (power_draw > 0)
		sink.add_thermal_energy(power_draw)	//gotta conserve that energy
	
	//Remix the resulting gases
	sink.update_values()
	source.update_values()
	
	return power_draw

//Calculates the amount of power needed to move one mole from source to sink.
/obj/machinery/atmospherics/proc/calculate_specific_power(datum/gas_mixture/source, datum/gas_mixture/sink)
	//Calculate the amount of energy required
	var/air_temperature = (sink.temperature > 0)? sink.temperature : source.temperature
	var/specific_entropy = sink.specific_entropy() - source.specific_entropy()	//environment is gaining moles, air_contents is loosing
	var/specific_power = 0	// W/mol
	
	//If specific_entropy is < 0 then transfer_moles is limited by how powerful the pump is
	if (specific_entropy < 0)
		specific_power = -specific_entropy*air_temperature		//how much power we need per mole
	
	return specific_power

//Calculates the amount of power needed to move one mole of a certain gas from source to sink.
/obj/machinery/atmospherics/proc/calculate_specific_power_gas(var/gasid, datum/gas_mixture/source, datum/gas_mixture/sink)
	//Calculate the amount of energy required
	var/air_temperature = (sink.temperature > 0)? sink.temperature : source.temperature
	var/specific_entropy = sink.specific_entropy_gas(gasid) - source.specific_entropy_gas(gasid)	//environment is gaining moles, air_contents is loosing
	var/specific_power = 0	// W/mol
	
	//If specific_entropy is < 0 then transfer_moles is limited by how powerful the pump is
	if (specific_entropy < 0)
		specific_power = -specific_entropy*air_temperature		//how much power we need per mole
	
	return specific_power

//This proc handles power usages so that we only have to call use_power() when the pump is loaded but not at full load. 
/obj/machinery/atmospherics/proc/handle_pump_power_draw(var/usage_amount)
	if (usage_amount > active_power_usage - 5)
		update_use_power(2)
	else
		use_power = 1	//Don't update here. Sure, we will use more power than we are supposed to, but it's easier on CPU
		
		/* 
		//This is the correct way to update pump power usage. Unfortunately it is also pretty laggy.
		//Leaving this here in case someone finds a way to do this that doesn't involve doing area power updates all the time.
		update_use_power(1)
		
		if (usage_amount > idle_power_usage)
			use_power(round(usage_amount))
		*/

/*
//DEBUG
/var/global/enable_scrubbing = 0
/var/global/enable_vent_pump = 0
/var/global/enable_power_net = 0

/mob/verb/toggle_scrubbing()
	set name = "Toggle Scrubbing"
	set category = "Debug"
	enable_scrubbing = !enable_scrubbing
	world << "enable_scrubbing set to [enable_scrubbing]"

/mob/verb/toggle_vent_pump()
	set name = "Toggle Vent Pumps"
	set category = "Debug"
	enable_vent_pump = !enable_vent_pump
	world << "enable_vent_pump set to [enable_vent_pump]"

/mob/verb/toggle_pump_powernet()
	set name = "Toggle Pump Power Update"
	set category = "Debug"
	enable_power_net = !enable_power_net
	world << "enable_power_net set to [enable_power_net]"
*/