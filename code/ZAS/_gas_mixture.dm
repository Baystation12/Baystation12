/*
What are the archived variables for?
	Calculations are done using the archived variables with the results merged into the regular variables.
	This prevents race conditions that arise based on the order of tile processing.
*/

#define SPECIFIC_HEAT_TOXIN		200		// J/(mol*K)
#define SPECIFIC_HEAT_AIR		20		// J/(mol*K)
#define SPECIFIC_HEAT_CDO		30		// J/(mol*K)
#define HEAT_CAPACITY_CALCULATION(oxygen,carbon_dioxide,nitrogen,phoron) \
	max(0, carbon_dioxide * SPECIFIC_HEAT_CDO + (oxygen + nitrogen) * SPECIFIC_HEAT_AIR + phoron * SPECIFIC_HEAT_TOXIN)

//we should really have a datum for each gas instead of a bunch of constants
#define MOL_MASS_O2			0.032	// kg/mol
#define MOL_MASS_N2			0.028	// kg/mol
#define MOL_MASS_CDO		0.044	// kg/mol
#define MOL_MASS_PHORON		0.289	// kg/mol

#define MINIMUM_HEAT_CAPACITY	0.0003
#define QUANTIZE(variable)		(round(variable,0.0001))
#define TRANSFER_FRACTION 5 //What fraction (1/#) of the air difference to try and transfer

#define SPECIFIC_ENTROPY_VACUUM		1500	//technically vacuum doesn't have a specific entropy. Just use a really big number here to show that it's easy to add gas to vacuum and hard to take gas out.

/hook/startup/proc/createGasOverlays()
	plmaster = new /obj/effect/overlay()
	plmaster.icon = 'icons/effects/tile_effects.dmi'
	plmaster.icon_state = "phoron"
	plmaster.layer = FLY_LAYER
	plmaster.mouse_opacity = 0

	slmaster = new /obj/effect/overlay()
	slmaster.icon = 'icons/effects/tile_effects.dmi'
	slmaster.icon_state = "sleeping_agent"
	slmaster.layer = FLY_LAYER
	slmaster.mouse_opacity = 0
	return 1

/datum/gas/sleeping_agent/specific_heat = 40 //These are used for the "Trace Gases" stuff, but is buggy. //J/(mol*K)

/datum/gas/oxygen_agent_b/specific_heat = 300	//J/(mol*K)

/datum/gas/volatile_fuel/specific_heat = 30		//J/(mol*K)

/datum/gas
	var/moles = 0

	var/specific_heat = 0

	var/moles_archived = 0

/datum/gas_mixture/
	var/oxygen = 0		//Holds the "moles" of each of the four gases.
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/phoron = 0

	var/total_moles = 0	//Updated when a reaction occurs.

	var/volume = CELL_VOLUME

	var/temperature = 0 //in Kelvin, use calculate_temperature() to modify

	var/group_multiplier = 1
				//Size of the group this gas_mixture is representing.
				//=1 for singletons

	var/graphic

	var/list/datum/gas/trace_gases = list() //Seemed to be a good idea that was abandoned

	var/tmp/oxygen_archived //These are variables for use with the archived data
	var/tmp/carbon_dioxide_archived
	var/tmp/nitrogen_archived
	var/tmp/phoron_archived

	var/tmp/temperature_archived

	var/tmp/graphic_archived = 0
	var/tmp/fuel_burnt = 0

	var/reacting = 0

//FOR THE LOVE OF GOD PLEASE USE THIS PROC
//Call it with negative numbers to remove gases.

/datum/gas_mixture/proc/adjust(o2 = 0, co2 = 0, n2 = 0, tx = 0, list/datum/gas/traces = list())
	//Purpose: Adjusting the gases within a airmix
	//Called by: Nothing, yet!
	//Inputs: The values of the gases to adjust
	//Outputs: null

	oxygen = max(0, oxygen + o2)
	carbon_dioxide = max(0, carbon_dioxide + co2)
	nitrogen = max(0, nitrogen + n2)
	phoron = max(0, phoron + tx)

	//handle trace gasses
	for(var/datum/gas/G in traces)
		var/datum/gas/T = locate(G.type) in trace_gases
		if(T)
			T.moles = max(G.moles + T.moles, 0)
		else if(G.moles > 0)
			trace_gases |= G
	update_values()
	return

		//tg seems to like using these a lot
/datum/gas_mixture/proc/return_temperature()
	return temperature


/datum/gas_mixture/proc/return_volume()
	return max(0, volume)


/datum/gas_mixture/proc/thermal_energy()
	return temperature*heat_capacity()

///////////////////////////////
//PV=nRT - related procedures//
///////////////////////////////

/datum/gas_mixture/proc/heat_capacity()
	//Purpose: Returning the heat capacity of the gas mix
	//Called by: UNKNOWN
	//Inputs: None
	//Outputs: Heat capacity

	var/heat_capacity = HEAT_CAPACITY_CALCULATION(oxygen,carbon_dioxide,nitrogen,phoron)

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			heat_capacity += trace_gas.moles*trace_gas.specific_heat

	return max(MINIMUM_HEAT_CAPACITY,heat_capacity)

/datum/gas_mixture/proc/heat_capacity_archived()
	//Purpose: Returning the archived heat capacity of the gas mix
	//Called by: UNKNOWN
	//Inputs: None
	//Outputs: Archived heat capacity

	var/heat_capacity_archived = HEAT_CAPACITY_CALCULATION(oxygen_archived,carbon_dioxide_archived,nitrogen_archived,phoron_archived)

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			heat_capacity_archived += trace_gas.moles_archived*trace_gas.specific_heat

	return max(MINIMUM_HEAT_CAPACITY,heat_capacity_archived)

/datum/gas_mixture/proc/add_thermal_energy(var/thermal_energy)
	//Purpose: Adjusting temperature based on thermal energy transfer
	//Called by: Anyone who wants to add or remove energy from the gas mix
	//Inputs: An amount of energy in J to be added. Negative values remove energy.
	//Outputs: The actual thermal energy change.
	
	var/old_temperature = temperature
	var/heat_capacity = heat_capacity()
	
	temperature += thermal_energy/heat_capacity
	if (temperature < TCMB)
		temperature = TCMB
	
	return (temperature - old_temperature)*heat_capacity

/datum/gas_mixture/proc/get_thermal_energy_change(var/new_temperature)
	//Purpose: Determining how much thermal energy is required
	//Called by: Anyone. Machines that want to adjust the temperature of a gas mix.
	//Inputs: None
	//Outputs: The amount of energy required to get to the new temperature in J. A negative value means that energy needs to be removed.
	
	return heat_capacity()*(new_temperature - temperature)


//This is so overkill for spessmen it's hilarious.
//While this proc will return an accurate measure of the entropy, it's much easier to use the specific_entropy_change() proc.
/datum/gas_mixture/proc/specific_entropy()
	//Purpose: Returning the specific entropy of the gas mix, i.e. the entropy gained or lost per mole of gas added or removed.
	//Called by: Anyone who wants to know how much energy it takes to move gases around in a steady state process (e.g. gas pumps)
	//Inputs: None
	//Outputs: Specific Entropy.
	
	//Jut assume everything is an ideal gas, so we can use the Ideal Gas Sackur-Tetrode equation.
	//After we convert to moles and Liters and extract all those crazy constants inside the ln() we end up with:
	//S = R * moles * ( ln[ constant * volume / moles * (molecular_mass * internal_energy / moles)^(3/2) ] + 5/2 )
	//Where constant is IDEAL_GAS_ENTROPY_CONSTANT defined in setup.dm
	
	//We need to do this calculation for each type of gas in the mix and add them all up, to properly capture the entropy of mixing.
	//It would be nice if each gas type was a datum, then we could just iterate through a list
	
	//the number of moles inside the square root gets divided out
	var/sp_entropy_oxygen = ( log( IDEAL_GAS_ENTROPY_CONSTANT * volume / (oxygen + 0.001) * sqrt( ( MOL_MASS_O2 * SPECIFIC_HEAT_AIR * (temperature + 1) ) ** 3 ) + 1) +  5/2  )
	
	var/sp_entropy_nitrogen = ( log( IDEAL_GAS_ENTROPY_CONSTANT * volume / (nitrogen + 0.001) * sqrt( ( MOL_MASS_N2 * SPECIFIC_HEAT_AIR * (temperature + 1) ) ** 3 ) + 1 ) +  5/2  )
	
	var/sp_entropy_carbon_dioxide = ( log( IDEAL_GAS_ENTROPY_CONSTANT * volume / (carbon_dioxide + 0.001) * sqrt( ( MOL_MASS_CDO * SPECIFIC_HEAT_CDO * (temperature + 1) + 1 ) ** 3 ) ) +  5/2  )
	
	var/sp_entropy_phoron = ( log( IDEAL_GAS_ENTROPY_CONSTANT * volume / (phoron + 0.001) * sqrt( ( MOL_MASS_PHORON * SPECIFIC_HEAT_TOXIN * (temperature + 1) ) ** 3 ) + 1 ) +  5/2  )
	
	if (total_moles > 0)
		var/oxygen_ratio = oxygen/total_moles
		var/nitrogen_ratio = nitrogen/total_moles
		var/carbon_dioxide_ratio = carbon_dioxide/total_moles
		var/phoron_ratio = phoron/total_moles
		
		return R_IDEAL_GAS_EQUATION * ( oxygen_ratio*sp_entropy_oxygen + nitrogen_ratio*sp_entropy_nitrogen  + carbon_dioxide_ratio*sp_entropy_carbon_dioxide  + phoron_ratio*sp_entropy_phoron )
	
	return SPECIFIC_ENTROPY_VACUUM

/datum/gas_mixture/proc/total_moles()
	return total_moles
	/*var/moles = oxygen + carbon_dioxide + nitrogen + phoron

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			moles += trace_gas.moles
	return moles*/

/datum/gas_mixture/proc/return_pressure()
	//Purpose: Calculating Current Pressure
	//Called by:
	//Inputs: None
	//Outputs: Gas pressure.

	if(volume>0)
		return total_moles()*R_IDEAL_GAS_EQUATION*temperature/volume
	return 0

//		proc/return_temperature()
			//Purpose:
			//Inputs:
			//Outputs:

//			return temperature

//		proc/return_volume()
			//Purpose:
			//Inputs:
			//Outputs:

//			return max(0, volume)

//		proc/thermal_energy()
			//Purpose:
			//Inputs:
			//Outputs:

//			return temperature*heat_capacity()

/datum/gas_mixture/proc/update_values()
	//Purpose: Calculating and storing values which were normally called CONSTANTLY
	//Called by: Anything that changes values within a gas mix.
	//Inputs: None
	//Outputs: None

	total_moles = oxygen + carbon_dioxide + nitrogen + phoron

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			total_moles += trace_gas.moles

	return

////////////////////////////////////////////
//Procedures used for very specific events//
////////////////////////////////////////////

/datum/gas_mixture/proc/check_tile_graphic()
	//Purpose: Calculating the graphic for a tile
	//Called by: Turfs updating
	//Inputs: None
	//Outputs: 1 if graphic changed, 0 if unchanged

	graphic = 0
	if(phoron > MOLES_PHORON_VISIBLE)
		graphic = 1
	else if(length(trace_gases))
		var/datum/gas/sleeping_agent = locate(/datum/gas/sleeping_agent) in trace_gases
		if(sleeping_agent && (sleeping_agent.moles > 1))
			graphic = 2
		else
			graphic = 0

	return graphic != graphic_archived

/datum/gas_mixture/proc/react(atom/dump_location)
	//Purpose: Calculating if it is possible for a fire to occur in the airmix
	//Called by: Air mixes updating?
	//Inputs: None
	//Outputs: If a fire occured

	 //set to 1 if a notable reaction occured (used by pipe_network)

	zburn(null)

	return reacting

/*
/datum/gas_mixture/proc/fire()
	//Purpose: Calculating any fire reactions.
	//Called by: react() (See above)
	//Inputs: None
	//Outputs: How much fuel burned

	return zburn(null)

	var/energy_released = 0
	var/old_heat_capacity = heat_capacity()

	var/datum/gas/volatile_fuel/fuel_store = locate(/datum/gas/volatile_fuel) in trace_gases
	if(fuel_store) //General volatile gas burn
		var/burned_fuel = 0

		if(oxygen < fuel_store.moles)
			burned_fuel = oxygen
			fuel_store.moles -= burned_fuel
			oxygen = 0
		else
			burned_fuel = fuel_store.moles
			oxygen -= fuel_store.moles
			del(fuel_store)

		energy_released += FIRE_CARBON_ENERGY_RELEASED * burned_fuel
		carbon_dioxide += burned_fuel
		fuel_burnt += burned_fuel

	//Handle phoron burning
	if(toxins > MINIMUM_HEAT_CAPACITY)
		var/phoron_burn_rate = 0
		var/oxygen_burn_rate = 0
		//more phoron released at higher temperatures
		var/temperature_scale
		if(temperature > PLASMA_UPPER_TEMPERATURE)
			temperature_scale = 1
		else
			temperature_scale = (temperature-PLASMA_MINIMUM_BURN_TEMPERATURE)/(PLASMA_UPPER_TEMPERATURE-PLASMA_MINIMUM_BURN_TEMPERATURE)
		if(temperature_scale > 0)
			oxygen_burn_rate = 1.4 - temperature_scale
			if(oxygen > toxins*PLASMA_OXYGEN_FULLBURN)
				phoron_burn_rate = (toxins*temperature_scale)/4
			else
				phoron_burn_rate = (temperature_scale*(oxygen/PLASMA_OXYGEN_FULLBURN))/4
			if(phoron_burn_rate > MINIMUM_HEAT_CAPACITY)
				toxins -= phoron_burn_rate
				oxygen -= phoron_burn_rate*oxygen_burn_rate
				carbon_dioxide += phoron_burn_rate

				energy_released += FIRE_PLASMA_ENERGY_RELEASED * (phoron_burn_rate)

				fuel_burnt += (phoron_burn_rate)*(1+oxygen_burn_rate)

	if(energy_released > 0)
		var/new_heat_capacity = heat_capacity()
		if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
			temperature = (temperature*old_heat_capacity + energy_released)/new_heat_capacity
	update_values()

	return fuel_burnt*/

//////////////////////////////////////////////
//Procs for general gas spread calculations.//
//////////////////////////////////////////////


/datum/gas_mixture/proc/archive()
	//Purpose: Archives the current gas values
	//Called by: UNKNOWN
	//Inputs: None
	//Outputs: 1

	oxygen_archived = oxygen
	carbon_dioxide_archived = carbon_dioxide
	nitrogen_archived =  nitrogen
	phoron_archived = phoron

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			trace_gas.moles_archived = trace_gas.moles

	temperature_archived = temperature

	graphic_archived = graphic

	return 1

/datum/gas_mixture/proc/check_then_merge(datum/gas_mixture/giver)
	//Purpose: Similar to merge(...) but first checks to see if the amount of air assumed is small enough
	//	that group processing is still accurate for source (aborts if not)
	//Called by: airgroups/machinery expelling air, ?
	//Inputs: The gas to try and merge
	//Outputs: 1 on successful merge.  0 otherwise.

	if(!giver)
		return 0
	if(((giver.oxygen > MINIMUM_AIR_TO_SUSPEND) && (giver.oxygen >= oxygen*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((giver.carbon_dioxide > MINIMUM_AIR_TO_SUSPEND) && (giver.carbon_dioxide >= carbon_dioxide*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((giver.nitrogen > MINIMUM_AIR_TO_SUSPEND) && (giver.nitrogen >= nitrogen*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((giver.phoron > MINIMUM_AIR_TO_SUSPEND) && (giver.phoron >= phoron*MINIMUM_AIR_RATIO_TO_SUSPEND)))
		return 0
	if(abs(giver.temperature - temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND)
		return 0

	if(giver.trace_gases.len)
		for(var/datum/gas/trace_gas in giver.trace_gases)
			var/datum/gas/corresponding = locate(trace_gas.type) in trace_gases
			if((trace_gas.moles > MINIMUM_AIR_TO_SUSPEND) && (!corresponding || (trace_gas.moles >= corresponding.moles*MINIMUM_AIR_RATIO_TO_SUSPEND)))
				return 0

	return merge(giver)

/datum/gas_mixture/proc/merge(datum/gas_mixture/giver)
	//Purpose: Merges all air from giver into self. Deletes giver.
	//Called by: Machinery expelling air, check_then_merge, ?
	//Inputs: The gas to merge.
	//Outputs: 1

	if(!giver)
		return 0

	if(abs(temperature-giver.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()*group_multiplier
		var/giver_heat_capacity = giver.heat_capacity()*giver.group_multiplier
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (giver.temperature*giver_heat_capacity + temperature*self_heat_capacity)/combined_heat_capacity

	if((group_multiplier>1)||(giver.group_multiplier>1))
		oxygen += giver.oxygen*giver.group_multiplier/group_multiplier
		carbon_dioxide += giver.carbon_dioxide*giver.group_multiplier/group_multiplier
		nitrogen += giver.nitrogen*giver.group_multiplier/group_multiplier
		phoron += giver.phoron*giver.group_multiplier/group_multiplier
	else
		oxygen += giver.oxygen
		carbon_dioxide += giver.carbon_dioxide
		nitrogen += giver.nitrogen
		phoron += giver.phoron

	if(giver.trace_gases.len)
		for(var/datum/gas/trace_gas in giver.trace_gases)
			var/datum/gas/corresponding = locate(trace_gas.type) in trace_gases
			if(!corresponding)
				corresponding = new trace_gas.type()
				trace_gases += corresponding
			corresponding.moles += trace_gas.moles*giver.group_multiplier/group_multiplier
	update_values()

	// Let the garbage collector handle it, faster according to /tg/ testers
	//del(giver)
	return 1

/datum/gas_mixture/proc/remove(amount)
	//Purpose: Removes a certain number of moles from the air.
	//Called by: ?
	//Inputs: How many moles to remove.
	//Outputs: Removed air.

	var/sum = total_moles()
	amount = min(amount,sum) //Can not take more air than tile has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new


	removed.oxygen = QUANTIZE((oxygen/sum)*amount)
	removed.nitrogen = QUANTIZE((nitrogen/sum)*amount)
	removed.carbon_dioxide = QUANTIZE((carbon_dioxide/sum)*amount)
	removed.phoron = QUANTIZE(((phoron/sum)*amount))

	oxygen -= removed.oxygen/group_multiplier
	nitrogen -= removed.nitrogen/group_multiplier
	carbon_dioxide -= removed.carbon_dioxide/group_multiplier
	phoron -= removed.phoron/group_multiplier

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			var/datum/gas/corresponding = new trace_gas.type()
			removed.trace_gases += corresponding

			corresponding.moles = ((trace_gas.moles/sum)*amount)
			trace_gas.moles -= (corresponding.moles/group_multiplier)

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

/datum/gas_mixture/proc/remove_ratio(ratio)
	//Purpose: Removes a certain ratio of the air.
	//Called by: ?
	//Inputs: Percentage to remove.
	//Outputs: Removed air.

	if(ratio <= 0)
		return null

	ratio = min(ratio, 1)

	var/datum/gas_mixture/removed = new

	removed.oxygen = QUANTIZE(oxygen*ratio)
	removed.nitrogen = QUANTIZE(nitrogen*ratio)
	removed.carbon_dioxide = QUANTIZE(carbon_dioxide*ratio)
	removed.phoron = QUANTIZE(phoron*ratio)

	oxygen -= removed.oxygen/group_multiplier
	nitrogen -= removed.nitrogen/group_multiplier
	carbon_dioxide -= removed.carbon_dioxide/group_multiplier
	phoron -= removed.phoron/group_multiplier

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			var/datum/gas/corresponding = new trace_gas.type()
			removed.trace_gases += corresponding

			corresponding.moles = trace_gas.moles*ratio
			trace_gas.moles -= corresponding.moles/group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

/datum/gas_mixture/proc/check_then_remove(amount)
	//Purpose: Similar to remove(...) but first checks to see if the amount of air removed is small enough
	//	that group processing is still accurate for source (aborts if not)
	//Called by: ?
	//Inputs: Number of moles to remove
	//Outputs: Removed air or 0 if it can remove air or not.

	amount = min(amount,total_moles()) //Can not take more air than tile has!

	if((amount > MINIMUM_AIR_RATIO_TO_SUSPEND) && (amount > total_moles()*MINIMUM_AIR_RATIO_TO_SUSPEND))
		return 0

	return remove(amount)

/datum/gas_mixture/proc/copy_from(datum/gas_mixture/sample)
	//Purpose: Duplicates the sample air mixture.
	//Called by: airgroups splitting, ?
	//Inputs: Gas to copy
	//Outputs: 1

	oxygen = sample.oxygen
	carbon_dioxide = sample.carbon_dioxide
	nitrogen = sample.nitrogen
	phoron = sample.phoron
	total_moles = sample.total_moles()

	trace_gases.len=null
	if(sample.trace_gases.len > 0)
		for(var/datum/gas/trace_gas in sample.trace_gases)
			var/datum/gas/corresponding = new trace_gas.type()
			trace_gases += corresponding

			corresponding.moles = trace_gas.moles

	temperature = sample.temperature

	return 1

/datum/gas_mixture/proc/check_gas_mixture(datum/gas_mixture/sharer)
	//Purpose: Telling if one or both airgroups needs to disable group processing.
	//Called by: Airgroups sharing air, checking if group processing needs disabled.
	//Inputs: Gas to compare from other airgroup
	//Outputs: 0 if the self-check failed (local airgroup breaks?)
	//   then -1 if sharer-check failed (sharing airgroup breaks?)
	//   then 1 if both checks pass (share succesful?)
	if(!istype(sharer))
		return

	var/delta_oxygen = QUANTIZE(oxygen_archived - sharer.oxygen_archived)/TRANSFER_FRACTION
	var/delta_carbon_dioxide = QUANTIZE(carbon_dioxide_archived - sharer.carbon_dioxide_archived)/TRANSFER_FRACTION
	var/delta_nitrogen = QUANTIZE(nitrogen_archived - sharer.nitrogen_archived)/TRANSFER_FRACTION
	var/delta_phoron = QUANTIZE(phoron_archived - sharer.phoron_archived)/TRANSFER_FRACTION

	var/delta_temperature = (temperature_archived - sharer.temperature_archived)

	if(((abs(delta_oxygen) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_oxygen) >= oxygen_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_carbon_dioxide) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_carbon_dioxide) >= carbon_dioxide_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_nitrogen) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_nitrogen) >= nitrogen_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_phoron) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_phoron) >= phoron_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)))
		return 0

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND)
		return 0

	if(sharer.trace_gases.len)
		for(var/datum/gas/trace_gas in sharer.trace_gases)
			if(trace_gas.moles_archived > MINIMUM_AIR_TO_SUSPEND*4)
				var/datum/gas/corresponding = locate(trace_gas.type) in trace_gases
				if(corresponding)
					if(trace_gas.moles_archived >= corresponding.moles_archived*MINIMUM_AIR_RATIO_TO_SUSPEND*4)
						return 0
				else
					return 0

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			if(trace_gas.moles_archived > MINIMUM_AIR_TO_SUSPEND*4)
				if(!locate(trace_gas.type) in sharer.trace_gases)
					return 0

	if(((abs(delta_oxygen) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_oxygen) >= sharer.oxygen_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_carbon_dioxide) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_carbon_dioxide) >= sharer.carbon_dioxide_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_nitrogen) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_nitrogen) >= sharer.nitrogen_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_phoron) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_phoron) >= sharer.phoron_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)))
		return -1

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			if(trace_gas.moles_archived > MINIMUM_AIR_TO_SUSPEND*4)
				var/datum/gas/corresponding = locate(trace_gas.type) in sharer.trace_gases
				if(corresponding)
					if(trace_gas.moles_archived >= corresponding.moles_archived*MINIMUM_AIR_RATIO_TO_SUSPEND*4)
						return -1
				else
					return -1

	return 1

/datum/gas_mixture/proc/check_turf(turf/model)
	//Purpose: Used to compare the gases in an unsimulated turf with the gas in a simulated one.
	//Called by: Sharing air (mimicing) with adjacent unsimulated turfs
	//Inputs: Unsimulated turf
	//Outputs: 1 if safe to mimic, 0 if needs to break airgroup.

	var/delta_oxygen = (oxygen_archived - model.oxygen)/TRANSFER_FRACTION
	var/delta_carbon_dioxide = (carbon_dioxide_archived - model.carbon_dioxide)/TRANSFER_FRACTION
	var/delta_nitrogen = (nitrogen_archived - model.nitrogen)/TRANSFER_FRACTION
	var/delta_phoron = (phoron_archived - model.phoron)/TRANSFER_FRACTION

	var/delta_temperature = (temperature_archived - model.temperature)

	if(((abs(delta_oxygen) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_oxygen) >= oxygen_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_carbon_dioxide) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_carbon_dioxide) >= carbon_dioxide_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_nitrogen) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_nitrogen) >= nitrogen_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)) \
		|| ((abs(delta_phoron) > MINIMUM_AIR_TO_SUSPEND) && (abs(delta_phoron) >= phoron_archived*MINIMUM_AIR_RATIO_TO_SUSPEND)))
		return 0
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND)
		return 0

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			if(trace_gas.moles_archived > MINIMUM_AIR_TO_SUSPEND*4)
				return 0

	return 1

/datum/gas_mixture/proc/share(datum/gas_mixture/sharer)
	//Purpose: Used to transfer gas from a more pressurised tile to a less presurised tile
	//    (Two directional, if the other tile is more pressurised, air travels to current tile)
	//Called by: Sharing air with adjacent simulated turfs
	//Inputs: Air datum to share with
	//Outputs: Amount of gas exchanged (Negative if lost air, positive if gained.)


	if(!istype(sharer))
		return

	var/delta_oxygen = QUANTIZE(oxygen_archived - sharer.oxygen_archived)/TRANSFER_FRACTION
	var/delta_carbon_dioxide = QUANTIZE(carbon_dioxide_archived - sharer.carbon_dioxide_archived)/TRANSFER_FRACTION
	var/delta_nitrogen = QUANTIZE(nitrogen_archived - sharer.nitrogen_archived)/TRANSFER_FRACTION
	var/delta_phoron = QUANTIZE(phoron_archived - sharer.phoron_archived)/TRANSFER_FRACTION

	var/delta_temperature = (temperature_archived - sharer.temperature_archived)

	var/old_self_heat_capacity = 0
	var/old_sharer_heat_capacity = 0

	var/heat_self_to_sharer = 0
	var/heat_capacity_self_to_sharer = 0
	var/heat_sharer_to_self = 0
	var/heat_capacity_sharer_to_self = 0

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)

		var/delta_air = delta_oxygen+delta_nitrogen
		if(delta_air)
			var/air_heat_capacity = SPECIFIC_HEAT_AIR*delta_air
			if(delta_air > 0)
				heat_self_to_sharer += air_heat_capacity*temperature_archived
				heat_capacity_self_to_sharer += air_heat_capacity
			else
				heat_sharer_to_self -= air_heat_capacity*sharer.temperature_archived
				heat_capacity_sharer_to_self -= air_heat_capacity

		if(delta_carbon_dioxide)
			var/carbon_dioxide_heat_capacity = SPECIFIC_HEAT_CDO*delta_carbon_dioxide
			if(delta_carbon_dioxide > 0)
				heat_self_to_sharer += carbon_dioxide_heat_capacity*temperature_archived
				heat_capacity_self_to_sharer += carbon_dioxide_heat_capacity
			else
				heat_sharer_to_self -= carbon_dioxide_heat_capacity*sharer.temperature_archived
				heat_capacity_sharer_to_self -= carbon_dioxide_heat_capacity

		if(delta_phoron)
			var/phoron_heat_capacity = SPECIFIC_HEAT_TOXIN*delta_phoron
			if(delta_phoron > 0)
				heat_self_to_sharer += phoron_heat_capacity*temperature_archived
				heat_capacity_self_to_sharer += phoron_heat_capacity
			else
				heat_sharer_to_self -= phoron_heat_capacity*sharer.temperature_archived
				heat_capacity_sharer_to_self -= phoron_heat_capacity

		old_self_heat_capacity = heat_capacity()*group_multiplier
		old_sharer_heat_capacity = sharer.heat_capacity()*sharer.group_multiplier

	oxygen -= delta_oxygen/group_multiplier
	sharer.oxygen += delta_oxygen/sharer.group_multiplier

	carbon_dioxide -= delta_carbon_dioxide/group_multiplier
	sharer.carbon_dioxide += delta_carbon_dioxide/sharer.group_multiplier

	nitrogen -= delta_nitrogen/group_multiplier
	sharer.nitrogen += delta_nitrogen/sharer.group_multiplier

	phoron -= delta_phoron/group_multiplier
	sharer.phoron += delta_phoron/sharer.group_multiplier

	var/moved_moles = (delta_oxygen + delta_carbon_dioxide + delta_nitrogen + delta_phoron)

	var/list/trace_types_considered = list()

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)

			var/datum/gas/corresponding = locate(trace_gas.type) in sharer.trace_gases
			var/delta = 0

			if(corresponding)
				delta = QUANTIZE(trace_gas.moles_archived - corresponding.moles_archived)/TRANSFER_FRACTION
			else
				corresponding = new trace_gas.type()
				sharer.trace_gases += corresponding

				delta = trace_gas.moles_archived/TRANSFER_FRACTION

			trace_gas.moles -= delta/group_multiplier
			corresponding.moles += delta/sharer.group_multiplier

			if(delta)
				var/individual_heat_capacity = trace_gas.specific_heat*delta
				if(delta > 0)
					heat_self_to_sharer += individual_heat_capacity*temperature_archived
					heat_capacity_self_to_sharer += individual_heat_capacity
				else
					heat_sharer_to_self -= individual_heat_capacity*sharer.temperature_archived
					heat_capacity_sharer_to_self -= individual_heat_capacity

			moved_moles += delta

			trace_types_considered += trace_gas.type


	if(sharer.trace_gases.len)
		for(var/datum/gas/trace_gas in sharer.trace_gases)
			if(trace_gas.type in trace_types_considered) continue
			else
				var/datum/gas/corresponding
				var/delta = 0

				corresponding = new trace_gas.type()
				trace_gases += corresponding

				delta = trace_gas.moles_archived/TRANSFER_FRACTION

				trace_gas.moles -= delta/sharer.group_multiplier
				corresponding.moles += delta/group_multiplier

				//Guaranteed transfer from sharer to self
				var/individual_heat_capacity = trace_gas.specific_heat*delta
				heat_sharer_to_self += individual_heat_capacity*sharer.temperature_archived
				heat_capacity_sharer_to_self += individual_heat_capacity

				moved_moles += -delta
	update_values()
	sharer.update_values()

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/new_self_heat_capacity = old_self_heat_capacity + heat_capacity_sharer_to_self - heat_capacity_self_to_sharer
		var/new_sharer_heat_capacity = old_sharer_heat_capacity + heat_capacity_self_to_sharer - heat_capacity_sharer_to_self

		if(new_self_heat_capacity > MINIMUM_HEAT_CAPACITY)
			temperature = (old_self_heat_capacity*temperature - heat_capacity_self_to_sharer*temperature_archived + heat_capacity_sharer_to_self*sharer.temperature_archived)/new_self_heat_capacity

		if(new_sharer_heat_capacity > MINIMUM_HEAT_CAPACITY)
			sharer.temperature = (old_sharer_heat_capacity*sharer.temperature-heat_capacity_sharer_to_self*sharer.temperature_archived + heat_capacity_self_to_sharer*temperature_archived)/new_sharer_heat_capacity

			if(abs(old_sharer_heat_capacity) > MINIMUM_HEAT_CAPACITY)
				if(abs(new_sharer_heat_capacity/old_sharer_heat_capacity - 1) < 0.10) // <10% change in sharer heat capacity
					temperature_share(sharer, OPEN_HEAT_TRANSFER_COEFFICIENT)

	if((delta_temperature > MINIMUM_TEMPERATURE_TO_MOVE) || abs(moved_moles) > MINIMUM_MOLES_DELTA_TO_MOVE)
		var/delta_pressure = temperature_archived*(total_moles() + moved_moles) - sharer.temperature_archived*(sharer.total_moles() - moved_moles)
		return delta_pressure*R_IDEAL_GAS_EQUATION/volume

	else
		return 0

/datum/gas_mixture/proc/mimic(turf/model, border_multiplier)
	//Purpose: Used transfer gas from a more pressurised tile to a less presurised unsimulated tile.
	//Called by: "sharing" from unsimulated to simulated turfs.
	//Inputs: Unsimulated turf, Multiplier for gas transfer (optional)
	//Outputs: Amount of gas exchanged

	var/delta_oxygen = QUANTIZE(oxygen_archived - model.oxygen)/TRANSFER_FRACTION
	var/delta_carbon_dioxide = QUANTIZE(carbon_dioxide_archived - model.carbon_dioxide)/TRANSFER_FRACTION
	var/delta_nitrogen = QUANTIZE(nitrogen_archived - model.nitrogen)/TRANSFER_FRACTION
	var/delta_phoron = QUANTIZE(phoron_archived - model.phoron)/TRANSFER_FRACTION

	var/delta_temperature = (temperature_archived - model.temperature)

	var/heat_transferred = 0
	var/old_self_heat_capacity = 0
	var/heat_capacity_transferred = 0

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)

		var/delta_air = delta_oxygen+delta_nitrogen
		if(delta_air)
			var/air_heat_capacity = SPECIFIC_HEAT_AIR*delta_air
			heat_transferred -= air_heat_capacity*model.temperature
			heat_capacity_transferred -= air_heat_capacity

		if(delta_carbon_dioxide)
			var/carbon_dioxide_heat_capacity = SPECIFIC_HEAT_CDO*delta_carbon_dioxide
			heat_transferred -= carbon_dioxide_heat_capacity*model.temperature
			heat_capacity_transferred -= carbon_dioxide_heat_capacity

		if(delta_phoron)
			var/phoron_heat_capacity = SPECIFIC_HEAT_TOXIN*delta_phoron
			heat_transferred -= phoron_heat_capacity*model.temperature
			heat_capacity_transferred -= phoron_heat_capacity

		old_self_heat_capacity = heat_capacity()*group_multiplier

	if(border_multiplier)
		oxygen -= delta_oxygen*border_multiplier/group_multiplier
		carbon_dioxide -= delta_carbon_dioxide*border_multiplier/group_multiplier
		nitrogen -= delta_nitrogen*border_multiplier/group_multiplier
		phoron -= delta_phoron*border_multiplier/group_multiplier
	else
		oxygen -= delta_oxygen/group_multiplier
		carbon_dioxide -= delta_carbon_dioxide/group_multiplier
		nitrogen -= delta_nitrogen/group_multiplier
		phoron -= delta_phoron/group_multiplier

	var/moved_moles = (delta_oxygen + delta_carbon_dioxide + delta_nitrogen + delta_phoron)

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			var/delta = 0

			delta = trace_gas.moles_archived/TRANSFER_FRACTION

			if(border_multiplier)
				trace_gas.moles -= delta*border_multiplier/group_multiplier
			else
				trace_gas.moles -= delta/group_multiplier

			var/heat_cap_transferred = delta*trace_gas.specific_heat
			heat_transferred += heat_cap_transferred*temperature_archived
			heat_capacity_transferred += heat_cap_transferred
			moved_moles += delta
	update_values()

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/new_self_heat_capacity = old_self_heat_capacity - heat_capacity_transferred
		if(new_self_heat_capacity > MINIMUM_HEAT_CAPACITY)
			if(border_multiplier)
				temperature = (old_self_heat_capacity*temperature - heat_capacity_transferred*border_multiplier*temperature_archived)/new_self_heat_capacity
			else
				temperature = (old_self_heat_capacity*temperature - heat_capacity_transferred*border_multiplier*temperature_archived)/new_self_heat_capacity

		temperature_mimic(model, model.thermal_conductivity, border_multiplier)

	if((delta_temperature > MINIMUM_TEMPERATURE_TO_MOVE) || abs(moved_moles) > MINIMUM_MOLES_DELTA_TO_MOVE)
		var/delta_pressure = temperature_archived*(total_moles() + moved_moles) - model.temperature*(model.oxygen+model.carbon_dioxide+model.nitrogen+model.phoron)
		return delta_pressure*R_IDEAL_GAS_EQUATION/volume
	else
		return 0

/datum/gas_mixture/proc/check_both_then_temperature_share(datum/gas_mixture/sharer, conduction_coefficient)
	var/delta_temperature = (temperature_archived - sharer.temperature_archived)

	var/self_heat_capacity = heat_capacity_archived()
	var/sharer_heat_capacity = sharer.heat_capacity_archived()

	var/self_temperature_delta = 0
	var/sharer_temperature_delta = 0

	if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
		var/heat = conduction_coefficient*delta_temperature* \
			(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

		self_temperature_delta = -heat/(self_heat_capacity*group_multiplier)
		sharer_temperature_delta = heat/(sharer_heat_capacity*sharer.group_multiplier)
	else
		return 1

	if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
		&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
		return 0

	if((abs(sharer_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
		&& (abs(sharer_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*sharer.temperature_archived))
		return -1

	temperature += self_temperature_delta
	sharer.temperature += sharer_temperature_delta

	return 1
	//Logic integrated from: temperature_share(sharer, conduction_coefficient) for efficiency

/datum/gas_mixture/proc/check_me_then_temperature_share(datum/gas_mixture/sharer, conduction_coefficient)
	var/delta_temperature = (temperature_archived - sharer.temperature_archived)

	var/self_heat_capacity = heat_capacity_archived()
	var/sharer_heat_capacity = sharer.heat_capacity_archived()

	var/self_temperature_delta = 0
	var/sharer_temperature_delta = 0

	if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
		var/heat = conduction_coefficient*delta_temperature* \
			(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

		self_temperature_delta = -heat/(self_heat_capacity*group_multiplier)
		sharer_temperature_delta = heat/(sharer_heat_capacity*sharer.group_multiplier)
	else
		return 1

	if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
		&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
		return 0

	temperature += self_temperature_delta
	sharer.temperature += sharer_temperature_delta

	return 1
	//Logic integrated from: temperature_share(sharer, conduction_coefficient) for efficiency

/datum/gas_mixture/proc/check_me_then_temperature_turf_share(turf/simulated/sharer, conduction_coefficient)
	var/delta_temperature = (temperature_archived - sharer.temperature)

	var/self_temperature_delta = 0
	var/sharer_temperature_delta = 0

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity_archived()

		if((sharer.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*sharer.heat_capacity/(self_heat_capacity+sharer.heat_capacity))

			self_temperature_delta = -heat/(self_heat_capacity*group_multiplier)
			sharer_temperature_delta = heat/sharer.heat_capacity
	else
		return 1

	if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
		&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
		return 0

	temperature += self_temperature_delta
	sharer.temperature += sharer_temperature_delta

	return 1
	//Logic integrated from: temperature_turf_share(sharer, conduction_coefficient) for efficiency

/datum/gas_mixture/proc/check_me_then_temperature_mimic(turf/model, conduction_coefficient)
	var/delta_temperature = (temperature_archived - model.temperature)
	var/self_temperature_delta = 0

	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity_archived()

		if((model.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*model.heat_capacity/(self_heat_capacity+model.heat_capacity))

			self_temperature_delta = -heat/(self_heat_capacity*group_multiplier)

	if((abs(self_temperature_delta) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) \
		&& (abs(self_temperature_delta) > MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND*temperature_archived))
		return 0

	temperature += self_temperature_delta

	return 1
	//Logic integrated from: temperature_mimic(model, conduction_coefficient) for efficiency

/datum/gas_mixture/proc/temperature_share(datum/gas_mixture/sharer, conduction_coefficient)
	var/delta_temperature = (temperature_archived - sharer.temperature_archived)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity_archived()
		var/sharer_heat_capacity = sharer.heat_capacity_archived()
		if(!group_multiplier)
			message_admins("Error!  The gas mixture (ref \ref[src]) has no group multiplier!")
			return

		if((sharer_heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*sharer_heat_capacity/(self_heat_capacity+sharer_heat_capacity))

			temperature -= heat/(self_heat_capacity*group_multiplier)
			sharer.temperature += heat/(sharer_heat_capacity*sharer.group_multiplier)

/datum/gas_mixture/proc/temperature_mimic(turf/model, conduction_coefficient, border_multiplier)
	var/delta_temperature = (temperature - model.temperature)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()//_archived()
		if(!group_multiplier)
			message_admins("Error!  The gas mixture (ref \ref[src]) has no group multiplier!")
			return

		if((model.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*model.heat_capacity/(self_heat_capacity+model.heat_capacity))

			if(border_multiplier)
				temperature -= heat*border_multiplier/(self_heat_capacity*group_multiplier)
			else
				temperature -= heat/(self_heat_capacity*group_multiplier)

/datum/gas_mixture/proc/temperature_turf_share(turf/simulated/sharer, conduction_coefficient)
	var/delta_temperature = (temperature_archived - sharer.temperature)
	if(abs(delta_temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()

		if((sharer.heat_capacity > MINIMUM_HEAT_CAPACITY) && (self_heat_capacity > MINIMUM_HEAT_CAPACITY))
			var/heat = conduction_coefficient*delta_temperature* \
				(self_heat_capacity*sharer.heat_capacity/(self_heat_capacity+sharer.heat_capacity))

			temperature -= heat/(self_heat_capacity*group_multiplier)
			sharer.temperature += heat/sharer.heat_capacity

/datum/gas_mixture/proc/compare(datum/gas_mixture/sample)
	//Purpose: Compares sample to self to see if within acceptable ranges that group processing may be enabled
	//Called by: Airgroups trying to rebuild
	//Inputs: Gas mix to compare
	//Outputs: 1 if can rebuild, 0 if not.
	if(!sample) return 0


	if((abs(oxygen-sample.oxygen) > MINIMUM_AIR_TO_SUSPEND) && \
		((oxygen < (1-MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.oxygen) || (oxygen > (1+MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.oxygen)))
		return 0
	if((abs(nitrogen-sample.nitrogen) > MINIMUM_AIR_TO_SUSPEND) && \
		((nitrogen < (1-MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.nitrogen) || (nitrogen > (1+MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.nitrogen)))
		return 0
	if((abs(carbon_dioxide-sample.carbon_dioxide) > MINIMUM_AIR_TO_SUSPEND) && \
		((carbon_dioxide < (1-MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.carbon_dioxide) || (carbon_dioxide > (1+MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.carbon_dioxide)))
		return 0
	if((abs(phoron-sample.phoron) > MINIMUM_AIR_TO_SUSPEND) && \
		((phoron < (1-MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.phoron) || (phoron > (1+MINIMUM_AIR_RATIO_TO_SUSPEND)*sample.phoron)))
		return 0


	if(total_moles() > MINIMUM_AIR_TO_SUSPEND)
		if((abs(temperature-sample.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
			((temperature < (1-MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature) || (temperature > (1+MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)*sample.temperature)))
			//world << "temp fail [temperature] & [sample.temperature]"
			return 0
	var/check_moles
	if(sample.trace_gases.len)
		for(var/datum/gas/trace_gas in sample.trace_gases)
			var/datum/gas/corresponding = locate(trace_gas.type) in trace_gases
			if(corresponding)
				check_moles = corresponding.moles
			else
				check_moles = 0

			if((abs(trace_gas.moles - check_moles) > MINIMUM_AIR_TO_SUSPEND) && \
				((check_moles < (1-MINIMUM_AIR_RATIO_TO_SUSPEND)*trace_gas.moles) || (check_moles > (1+MINIMUM_AIR_RATIO_TO_SUSPEND)*trace_gas.moles)))
				return 0

	if(trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			var/datum/gas/corresponding = locate(trace_gas.type) in trace_gases
			if(corresponding)
				check_moles = corresponding.moles
			else
				check_moles = 0

			if((abs(trace_gas.moles - check_moles) > MINIMUM_AIR_TO_SUSPEND) && \
				((trace_gas.moles < (1-MINIMUM_AIR_RATIO_TO_SUSPEND)*check_moles) || (trace_gas.moles > (1+MINIMUM_AIR_RATIO_TO_SUSPEND)*check_moles)))
				return 0

	return 1

/datum/gas_mixture/proc/add(datum/gas_mixture/right_side)
	oxygen += right_side.oxygen
	carbon_dioxide += right_side.carbon_dioxide
	nitrogen += right_side.nitrogen
	phoron += right_side.phoron

	if(trace_gases.len || right_side.trace_gases.len)
		for(var/datum/gas/trace_gas in right_side.trace_gases)
			var/datum/gas/corresponding = locate(trace_gas.type) in trace_gases
			if(!corresponding)
				corresponding = new trace_gas.type()
				trace_gases += corresponding
			corresponding.moles += trace_gas.moles

	update_values()
	return 1

/datum/gas_mixture/proc/subtract(datum/gas_mixture/right_side)
	//Purpose: Subtracts right_side from air_mixture. Used to help turfs mingle
	//Called by: Pipelines ending in a break (or something)
	//Inputs: Gas mix to remove
	//Outputs: 1

	oxygen = max(oxygen - right_side.oxygen)
	carbon_dioxide = max(carbon_dioxide - right_side.carbon_dioxide)
	nitrogen = max(nitrogen - right_side.nitrogen)
	phoron = max(phoron - right_side.phoron)

	if(trace_gases.len || right_side.trace_gases.len)
		for(var/datum/gas/trace_gas in right_side.trace_gases)
			var/datum/gas/corresponding = locate(trace_gas.type) in trace_gases
			if(corresponding)
				corresponding.moles = max(0, corresponding.moles - trace_gas.moles)

	update_values()
	return 1

/datum/gas_mixture/proc/multiply(factor)
	oxygen *= factor
	carbon_dioxide *= factor
	nitrogen *= factor
	phoron *= factor

	if(trace_gases && trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			trace_gas.moles *= factor

	update_values()
	return 1

/datum/gas_mixture/proc/divide(factor)
	oxygen /= factor
	carbon_dioxide /= factor
	nitrogen /= factor
	phoron /= factor

	if(trace_gases && trace_gases.len)
		for(var/datum/gas/trace_gas in trace_gases)
			trace_gas.moles /= factor

	update_values()
	return 1
