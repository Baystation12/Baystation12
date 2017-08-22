/decl/xgm_gas/oxygen
	id = "oxygen"
	name = "Oxygen"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.032	// kg/mol

	flags = XGM_GAS_OXIDIZER | XGM_GAS_FUSION_FUEL

/decl/xgm_gas/nitrogen
	id = "nitrogen"
	name = "Nitrogen"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.028	// kg/mol

/decl/xgm_gas/carbon_dioxide
	id = "carbon_dioxide"
	name = "Carbon Dioxide"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol

/decl/xgm_gas/phoron
	id = "phoron"
	name = "Phoron"

	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	specific_heat = 200	// J/(mol*K)

	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	molar_mass = 0.405	// kg/mol

	tile_overlay = "phoron"
	overlay_limit = 0.7
	flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT | XGM_GAS_FUSION_FUEL

/decl/xgm_gas/sleeping_agent
	id = "sleeping_agent"
	name = "Sleeping Agent"
	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.044	// kg/mol. N2O

	tile_overlay = "sleeping_agent"
	overlay_limit = 1
	flags = XGM_GAS_OXIDIZER //N2O is a powerful oxidizer

/decl/xgm_gas/methane
	id = "methane"
	name = "Methane"

	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.016	// kg/mol

	flags = XGM_GAS_FUEL

/decl/xgm_gas/alium
	id = "aliether"
	name = "Aliether"

/decl/xgm_gas/alium/New()
	name = "Compound #[rand(100,999)]"
	specific_heat = rand(20, 400)	// J/(mol*K)
	molar_mass = rand(20,500)/100	// kg/mol
	if(prob(40))
		flags |= XGM_GAS_FUEL
	else if(prob(40)) //it's prooobably a bad idea for gas being oxidizer to itself.
		flags |= XGM_GAS_OXIDIZER
	if(prob(40))
		flags |= XGM_GAS_CONTAMINANT
	if(prob(40))
		flags |= XGM_GAS_FUSION_FUEL