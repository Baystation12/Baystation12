/datum/artifact_trigger/gas
	name = "concentration of a specific gas"
	toggle = FALSE
	var/list/gas_needed	//list of gas=percentage needed in air to activate

/datum/artifact_trigger/gas/New()
	if(!gas_needed)
		//pick from the subtypes traits if we don't spawn as one
		var/gas = pick(GAS_CO2, GAS_OXYGEN, GAS_NITROGEN, GAS_PHORON)
		name = "concentration of [gas]"
		gas_needed = list("[gas]" = 5)

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
	gas_needed = list(GAS_OXYGEN = 5)

/datum/artifact_trigger/gas/n2
	name = "concentration of nitrogen"
	gas_needed = list(GAS_NITROGEN = 5)

/datum/artifact_trigger/gas/phoron
	name = "concentration of phoron"
	gas_needed = list(GAS_PHORON = 5)
