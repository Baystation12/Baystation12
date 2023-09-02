/**
	Non-exhaustively setting the gas properties of various reagents.
	<https://www.engineeringtoolbox.com> & <https://webbook.nist.gov> are often helpful.
	gas_molar_mass: kg/mol
	gas_molar_heat_capacity: J/(mol*K)
*/


/datum/reagent/water/gas_molar_mass = 0.018
/datum/reagent/water/gas_molar_heat_capacity = 35.46


/datum/reagent/fuel/gas_flags = XGM_GAS_FUEL
/datum/reagent/fuel/gas_molar_mass = 0.15 // rough for kerosene
/datum/reagent/fuel/gas_molar_heat_capacity = 301.5


/datum/reagent/ethanol/New()
	..()
	if (strength <= 15) // drinks are hell
		gas_flags = XGM_GAS_FUEL
		gas_molar_mass = 0.046
		gas_molar_heat_capacity = 105.8


/datum/reagent/acetone/gas_flags = XGM_GAS_FUEL
/datum/reagent/acetone/gas_molar_mass = 0.058
/datum/reagent/acetone/gas_molar_heat_capacity = 124.7


/datum/reagent/hydrazine/gas_flags = XGM_GAS_FUEL
/datum/reagent/hydrazine/gas_molar_mass = 0.032
/datum/reagent/hydrazine/gas_molar_heat_capacity = 88.15


/datum/reagent/napalm/gas_flags = XGM_GAS_FUEL
/datum/reagent/napalm/gas_molar_mass = 0.15
/datum/reagent/napalm/gas_molar_heat_capacity = 180


/datum/reagent/oil/gas_flags = XGM_GAS_FUEL
/datum/reagent/oil/gas_molar_mass = 0.082
/datum/reagent/oil/gas_molar_heat_capacity = 174.66


/datum/reagent/toxin/phoron/gas_flags = XGM_GAS_FUEL
/datum/reagent/toxin/phoron/gas_molar_mass = 0.367
/datum/reagent/toxin/phoron/gas_molar_heat_capacity = 79.89
