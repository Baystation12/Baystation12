/*
	Atmos processes
	
	These procs generalize various processes used by atmos machinery, such as pumping, filtering, or scrubbing gas, allowing them to be reused elsewhere.
	If no gas was moved/pumped/filtered/whatever, they return a negative number.
	Otherwise they return the amount of energy needed to do whatever it is they do (equivalently power if done over 1 second).
	In the case of free-flowing gas you can do things with gas and still use 0 power, hence the distinction between negative and non-negative return values.
*/


/obj/machinery/atmospherics/var/last_flow_rate = 0	//Can't return multiple values, unfortunately

//Generalized gas pumping proc.
//Moves gas from one gas_mixture to another and returns the amount of power needed (assuming 1 second), or -1 if no gas was pumped.
//transfer_moles - Limits the amount of moles to transfer. The actual amount of gas moved may also be limited by available_power, if given.
//available_power - the maximum amount of power that may be used when moving gas. If null then the transfer is not limited by power.
/obj/machinery/atmospherics/proc/pump_gas(var/datum/gas_mixture/source, var/datum/gas_mixture/sink, var/transfer_moles = null, var/available_power = null)
	if (source.total_moles < MINUMUM_MOLES_TO_PUMP) //if we cant transfer enough gas just stop to avoid further processing
		return -1
	
	if (!transfer_moles)
		transfer_moles = source.total_moles
	else
		transfer_moles = min(source.total_moles, transfer_moles)
	
	//Calculate the amount of energy required and limit transfer_moles based on available power
	var/specific_power = calculate_specific_power(source, sink)/ATMOS_PUMP_EFFICIENCY //this has to be calculated before we modify any gas mixtures
	if (available_power && specific_power > 0)
		transfer_moles = min(transfer_moles, available_power / specific_power)
	
	if (transfer_moles < MINUMUM_MOLES_TO_PUMP) //if we cant transfer enough gas just stop to avoid further processing
		return -1
	
	last_flow_rate = (transfer_moles/source.total_moles)*source.volume //group_multiplier gets divided out here
	
	var/datum/gas_mixture/removed = source.remove(transfer_moles)
	if (!removed) //Just in case
		return -1
	
	var/power_draw = specific_power*transfer_moles
	if (power_draw > 0)
		removed.add_thermal_energy(power_draw) //1st law - energy is conserved
	
	sink.merge(removed)
	
	return power_draw

//Generalized gas scrubbing proc.
//Selectively moves specified gasses one gas_mixture to another and returns the amount of power needed (assuming 1 second), or -1 if no gas was filtered.
//filtering - A list of gasids to be scrubbed from source
//total_transfer_moles - Limits the amount of moles to scrub. The actual amount of gas scrubbed may also be limited by available_power, if given.
//available_power - the maximum amount of power that may be used when scrubbing gas. If null then the scrubbing is not limited by power.
/obj/machinery/atmospherics/proc/scrub_gas(var/list/filtering, var/datum/gas_mixture/source, var/datum/gas_mixture/sink, var/total_transfer_moles = null, var/available_power = null)
	if (source.total_moles < MINUMUM_MOLES_TO_FILTER) //if we cant transfer enough gas just stop to avoid further processing
		return -1

	filtering &= source.gas		//only filter gasses that are actually there.
	
	//Determine the specific power of each filterable gas type, and the total amount of filterable gas
	var/total_filterable_moles = 0
	var/list/specific_power_gas = list()	//the power required to remove one mole of pure gas, for each gas type
	for (var/g in filtering)
		if (source.gas[g] < MINUMUM_MOLES_TO_FILTER)
			continue
	
		var/specific_power = calculate_specific_power_gas(g, source, sink)/ATMOS_FILTER_EFFICIENCY
		specific_power_gas[g] = specific_power
		total_filterable_moles += source.gas[g]
	
	if (total_filterable_moles < MINUMUM_MOLES_TO_FILTER) //if we cant transfer enough gas just stop to avoid further processing
		return -1
	
	var/total_specific_power = 0		//the power required to remove one mole of filterable gas
	for (var/g in filtering)
		var/ratio = source.gas[g]/total_filterable_moles //this converts the specific power per mole of pure gas to specific power per mole of filterable gas mix
		total_specific_power = specific_power_gas[g]*ratio
	
	//Figure out how much of each gas to filter
	if (!total_transfer_moles)
		total_transfer_moles = total_filterable_moles
	else
		total_transfer_moles = min(total_transfer_moles, total_filterable_moles)
	
	//limit transfer_moles based on available power
	if (available_power && total_specific_power > 0)
		total_transfer_moles = min(total_transfer_moles, available_power/total_specific_power)
	
	if (total_transfer_moles < MINUMUM_MOLES_TO_FILTER) //if we cant transfer enough gas just stop to avoid further processing
		return -1
	
	var/power_draw = 0
	last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //group_multiplier gets divided out here
	for (var/g in filtering)
		var/transfer_moles = source.gas[g]
		//filter gas in proportion to the mole ratio
		transfer_moles = min(transfer_moles, total_transfer_moles*(source.gas[g]/total_filterable_moles))
		
		//use update=0. All the filtered gasses are supposed to be added simultaneously, so we update after the for loop.
		source.adjust_gas(g, -transfer_moles, update=0)
		sink.adjust_gas_temp(g, transfer_moles, source.temperature, update=0)
		
		power_draw += specific_power_gas[g]*transfer_moles
	
	//Remix the resulting gases
	sink.update_values()
	source.update_values()
	
	if (power_draw > 0)
		sink.add_thermal_energy(power_draw)	//gotta conserve that energy
	
	return power_draw

//Generalized gas filtering proc.
//Filtering is a bit different from scrubbing. Instead of selectively moving the targeted gas types from one gas mix to another, filtering splits 
//the input gas into two outputs: one that contains /only/ the targeted gas types, and another that completely clean of the targeted gas types.
//filtering - A list of gasids to be filtered. These gasses get moved to sink_filtered, while the other gasses get moved to sink_clean.
//total_transfer_moles - Limits the amount of moles to input. The actual amount of gas filtered may also be limited by available_power, if given.
//available_power - the maximum amount of power that may be used when filtering gas. If null then the filtering is not limited by power.
/obj/machinery/atmospherics/proc/filter_gas(var/list/filtering, var/datum/gas_mixture/source, var/datum/gas_mixture/sink_filtered, var/datum/gas_mixture/sink_clean, var/total_transfer_moles = null, var/available_power = null)
	if (source.total_moles < MINUMUM_MOLES_TO_FILTER) //if we cant transfer enough gas just stop to avoid further processing
		return -1

	filtering &= source.gas		//only filter gasses that are actually there.
	
	var/total_filterable_moles = 0
	var/total_unfilterable_moles = 0
	var/list/specific_power_gas = list()	//the power required to remove one mole of pure gas, for each gas type
	for (var/g in source.gas)
		if (source.gas[g] < MINUMUM_MOLES_TO_FILTER)
			continue
		
		if (g in filtering)
			specific_power_gas[g] = calculate_specific_power_gas(g, source, sink_filtered)/ATMOS_FILTER_EFFICIENCY
			total_filterable_moles += source.gas[g]
		else
			specific_power_gas[g] = calculate_specific_power_gas(g, source, sink_clean)/ATMOS_FILTER_EFFICIENCY
			total_unfilterable_moles += source.gas[g]
	
	var/total_specific_power = 0		//the power required to remove one mole of input gas
	for (var/g in source.gas)
		var/ratio = source.gas[g]/source.total_moles //converts the specific power per mole of pure gas to specific power per mole of input gas mix
		total_specific_power = specific_power_gas[g]*ratio
	
	//Figure out how much of each gas to filter
	if (!total_transfer_moles)
		total_transfer_moles = source.total_moles
	else
		total_transfer_moles = min(total_transfer_moles, source.total_moles)
	
	//limit transfer_moles based on available power
	if (available_power && total_specific_power > 0)
		total_transfer_moles = min(total_transfer_moles, available_power/total_specific_power)
	
	if (total_transfer_moles < MINUMUM_MOLES_TO_FILTER) //if we cant transfer enough gas just stop to avoid further processing
		return -1
	
	last_flow_rate = (total_transfer_moles/source.total_moles)*source.volume //group_multiplier gets divided out here
	
	var/datum/gas_mixture/removed = source.remove(total_transfer_moles)
	if (!removed) //Just in case
		return -1
	
	var/filtered_power_used = 0
	var/unfiltered_power_used = 0
	for (var/g in removed.gas)
		var/power_used = specific_power_gas[g]*removed.gas[g]
		
		if (g in filtering)
			//use update=0. All the filtered gasses are supposed to be added simultaneously, so we update after the for loop.
			sink_filtered.adjust_gas_temp(g, removed.gas[g], removed.temperature, update=0)
			filtered_power_used += power_used
		else
			unfiltered_power_used += power_used
	
	sink_filtered.update_values()
	sink_clean.merge(removed)
	
	if (filtered_power_used > 0)
		sink_filtered.add_thermal_energy(filtered_power_used) //1st law - energy is conserved
	if (unfiltered_power_used > 0)
		sink_clean.add_thermal_energy(unfiltered_power_used) //1st law - energy is conserved
	
	return filtered_power_used + unfiltered_power_used

/*
	Helper procs for various things.
*/

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
/obj/machinery/atmospherics/proc/handle_power_draw(var/usage_amount)
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