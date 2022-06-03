/**
	Non-exhaustively setting the gas properties of various reagents.
	<https://www.engineeringtoolbox.com> & <https://webbook.nist.gov> are often helpful.
	gas_molar_mass: kg/mol
	gas_specific_heat: J/(mol*K)
*/


/datum/reagent/water/gas_molar_mass = 0.018
/datum/reagent/water/gas_specific_heat = 75.2


/datum/reagent/fuel/gas_flags = XGM_GAS_FUEL
/datum/reagent/fuel/gas_molar_mass = 0.15 // rough for kerosene
/datum/reagent/fuel/gas_specific_heat = 200


/datum/reagent/ethanol/New()
	..()
	if (strength <= 15) // drinks are hell
		gas_flags = XGM_GAS_FUEL
		gas_molar_mass = 0.046
		gas_specific_heat = 118.4


/datum/reagent/acetone/gas_flags = XGM_GAS_FUEL
/datum/reagent/acetone/gas_molar_mass = 0.058
/datum/reagent/acetone/gas_specific_heat = 124.5


/datum/reagent/hydrazine/gas_flags = XGM_GAS_FUEL
/datum/reagent/hydrazine/gas_molar_mass = 0.032
/datum/reagent/hydrazine/gas_specific_heat = 121.52


/datum/reagent/napalm/gas_flags = XGM_GAS_FUEL
/datum/reagent/napalm/gas_molar_mass = 0.15
/datum/reagent/napalm/gas_specific_heat = 180


/datum/reagent/oil/gas_flags = XGM_GAS_FUEL
/datum/reagent/oil/gas_molar_mass = 0.49
/datum/reagent/oil/gas_specific_heat = 190


/datum/reagent/toxin/phoron/gas_flags = XGM_GAS_FUEL
/datum/reagent/toxin/phoron/gas_molar_mass = 0.405
/datum/reagent/toxin/phoron/gas_specific_heat = 200
