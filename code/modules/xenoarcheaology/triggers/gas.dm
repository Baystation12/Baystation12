/datum/artifact_trigger/gas
	name = "concentration of a specific gas"
	toggle = FALSE
	var/list/gas_needed	//list of gas=percentage needed in air to activate

/datum/artifact_trigger/gas/New()
	if(!gas_needed)
		gas_needed = list(pick(gas_data.gases) = rand(1,10))

/datum/artifact_trigger/gas/on_gas_exposure(datum/gas_mixture/gas)
	. = TRUE
	for(var/g in gas_needed)
		var/percentage = round(gas.gas[g]/gas.total_moles * 100, 0.01)
		if(percentage < gas_needed[g])
			return FALSE

/datum/artifact_trigger/gas/co2
	name = "concentration of CO2"
	gas_needed = list(GAS_CO2 = 5)

/datum/artifact_trigger/gas/o2
	name = "concentration of oxygen"
	gas_needed = list(GAS_O2 = 5)

/datum/artifact_trigger/gas/n2
	name = "concentration of nitrogen"
	gas_needed = list(GAS_N2 = 5)

/datum/artifact_trigger/gas/phoron
	name = "concentration of phoron"
	gas_needed = list(GAS_PHORON = 5)