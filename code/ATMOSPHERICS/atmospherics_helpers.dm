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
	if (!isnull(available_power) && specific_power > 0)
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
	if (!isnull(available_power) && total_specific_power > 0)
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
	
	var/total_specific_power = 0		//the power required to remove one mole of input gas
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
			
		var/ratio = source.gas[g]/source.total_moles //converts the specific power per mole of pure gas to specific power per mole of input gas mix
		total_specific_power = specific_power_gas[g]*ratio
	
	//Figure out how much of each gas to filter
	if (!total_transfer_moles)
		total_transfer_moles = source.total_moles
	else
		total_transfer_moles = min(total_transfer_moles, source.total_moles)
	
	//limit transfer_moles based on available power
	if (!isnull(available_power) && total_specific_power > 0)
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
	
	//1LTD energy is conserved
	if (filtered_power_used > 0)
		sink_filtered.add_thermal_energy(filtered_power_used)
	if (unfiltered_power_used > 0)
		sink_clean.add_thermal_energy(unfiltered_power_used)
	
	return filtered_power_used + unfiltered_power_used

//Similar deal as the other atmos process procs.
//mix_sources maps input gas mixtures to mix ratios. The mix ratios MUST add up to 1.
/obj/machinery/atmospherics/proc/mix_gas(var/list/mix_sources, var/datum/gas_mixture/sink, var/total_transfer_moles = null, var/available_power = null)
	if (!mix_sources.len)
		return -1
	
	var/total_specific_power = 0
	var/total_mixing_moles = null
	var/total_input_volume = 0	//for flow rate calculation
	var/total_input_moles = 0	//for flow rate calculation
	var/list/source_specific_power = list()
	for (var/datum/gas_mixture/source in mix_sources)
		if (source.total_moles < MINUMUM_MOLES_TO_FILTER)
			return -1	//either mix at the set ratios or mix no gas at all
		
		var/mix_ratio = mix_sources[source]
		if (!mix_ratio)
			continue
		
		//mixing rate is limited by the source with the least amount of available gas
		if (isnull(total_mixing_moles))
			total_mixing_moles = source.total_moles/mix_ratio
		else
			total_mixing_moles = min(total_mixing_moles, source.total_moles/mix_ratio)
		
		source_specific_power[source] = calculate_specific_power(source, sink)*mix_ratio/ATMOS_FILTER_EFFICIENCY
		total_specific_power += source_specific_power[source]
		total_input_volume += source.volume
		total_input_moles += source.total_moles
	
	if (total_mixing_moles < MINUMUM_MOLES_TO_FILTER) //if we cant transfer enough gas just stop to avoid further processing
		return -1
	
	if (!total_transfer_moles)
		total_transfer_moles = total_mixing_moles
	else
		total_transfer_moles = min(total_mixing_moles, total_transfer_moles)
	
	//limit transfer_moles based on available power
	if (!isnull(available_power) && total_specific_power > 0)
		total_transfer_moles = min(total_transfer_moles, available_power / total_specific_power)
	
	if (total_transfer_moles < MINUMUM_MOLES_TO_FILTER) //if we cant transfer enough gas just stop to avoid further processing
		return -1
	
	last_flow_rate = (total_transfer_moles/total_input_moles)*total_input_volume //group_multiplier gets divided out here
	
	var/total_power_draw = 0
	for (var/datum/gas_mixture/source in mix_sources)
		var/mix_ratio = mix_sources[source]
		if (!mix_ratio)
			continue
		
		var/transfer_moles = total_transfer_moles * mix_ratio
		
		var/datum/gas_mixture/removed = source.remove(transfer_moles)
		
		var/power_draw = transfer_moles * source_specific_power[source]
		removed.add_thermal_energy(power_draw)	//conservation of energy
		total_power_draw += power_draw
		
		sink.merge(removed)
	
	return total_power_draw

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

//This proc handles power usages.
//Calling update_use_power() or use_power() too often will result in lag since updating area power can be costly.
//This proc implements an approximation scheme that will cause area power updates to be triggered less often.
//By having atmos machinery use this proc it is easy to change the power usage approximation for all atmos machines
/obj/machinery/atmospherics/proc/handle_power_draw(var/usage_amount)
	//***This scheme errs on the side of using more power. Using this will mean that sometimes atmos machines use more power than they need, but won't get power for free.
	if (usage_amount > idle_power_usage)
		update_use_power(1)
	else
		use_power = 1	//Don't update here. We will use more power than we are supposed to, but trigger less area power updates.
	
	switch (use_power)
		if (0) return 0
		if (1) return idle_power_usage
		if (2 to INFINITY) return active_power_usage
	
	/* Alternate power usage schemes
	
	//***This scheme has the most accurate power usage, but triggers area power updates too often.
	if (usage_amount > active_power_usage - 5)
		update_use_power(2)
	else
		update_use_power(1)
		
		if (usage_amount > idle_power_usage)
			use_power(round(usage_amount))
	
	//***This scheme errs on the side of using less power. Using this will mean that sometimes atmos machines get free power.
	if (usage_amount > active_power_usage - 5)
		update_use_power(2)
	else
		use_power = 1	//Don't need to update here.
	
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