/singleton/xgm_gas/oxygen
	id = GAS_OXYGEN
	name = "Oxygen"
	molar_heat_capacity = 29.34	// J/(mol*K)
	molar_mass = 0.032	// kg/mol
	flags = XGM_GAS_OXIDIZER | XGM_GAS_FUSION_FUEL
	breathed_product = /datum/reagent/oxygen
	symbol_html = "O<sub>2</sub>"
	symbol = "O2"


/singleton/xgm_gas/nitrogen
	id = GAS_NITROGEN
	name = "Nitrogen"
	molar_heat_capacity = 29.15
	molar_mass = 0.028
	symbol_html = "N<sub>2</sub>"
	symbol = "N2"

/singleton/xgm_gas/carbon_dioxide
	id = GAS_CO2
	name = "Carbon Dioxide"
	molar_heat_capacity = 36.40
	molar_mass = 0.044
	symbol_html = "CO<sub>2</sub>"
	symbol = "CO2"

/singleton/xgm_gas/methyl_bromide
	id = GAS_METHYL_BROMIDE
	name = "Methyl Bromide"
	molar_heat_capacity = 43.04
	molar_mass = 0.095
	breathed_product = /datum/reagent/toxin/methyl_bromide
	symbol_html = "CH<sub>3</sub>Br"
	symbol = "CH3Br"

/singleton/xgm_gas/phoron
	id = GAS_PHORON
	name = "Phoron"
	molar_heat_capacity = 79.89
	molar_mass = 0.367
	tile_color = "#ff9940"
	overlay_limit = 0.7
	flags = XGM_GAS_FUEL | XGM_GAS_CONTAMINANT | XGM_GAS_FUSION_FUEL
	breathed_product = /datum/reagent/toxin/phoron
	symbol_html = "Ph"
	symbol = "Ph"

/singleton/xgm_gas/sleeping_agent
	id = GAS_N2O
	name = "Nitrous Oxide"
	molar_heat_capacity = 34.01
	molar_mass = 0.044
	flags = XGM_GAS_OXIDIZER
	breathed_product = /datum/reagent/nitrous_oxide
	symbol_html = "N<sub>2</sub>O"
	symbol = "N2O"

/singleton/xgm_gas/methane
	id = GAS_METHANE
	name = "Methane"
	molar_heat_capacity = 34.90
	molar_mass = 0.016
	flags = XGM_GAS_FUEL
	symbol_html = "CH<sub>4</sub>"
	symbol = "CH4"

/singleton/xgm_gas/alium
	id = GAS_ALIEN
	name = "Aliether"
	hidden_from_codex = TRUE
	symbol_html = "X"
	symbol = "X"

/singleton/xgm_gas/alium/New()
	var/num = rand(100,999)
	name = "Compound #[num]"
	molar_heat_capacity = rand(100, 5000)
	molar_mass = rand(250, 400)/1000
	if(prob(40))
		flags |= XGM_GAS_FUEL
	else if(prob(40)) //it's prooobably a bad idea for gas being oxidizer to itself.
		flags |= XGM_GAS_OXIDIZER
	if(prob(40))
		flags |= XGM_GAS_CONTAMINANT
	if(prob(40))
		flags |= XGM_GAS_FUSION_FUEL

	symbol_html = "X<sup>[num]</sup>"
	symbol = "X-[num]"
	if(prob(50))
		tile_color = RANDOM_RGB
		overlay_limit = 0.5

/singleton/xgm_gas/hydrogen
	id = GAS_HYDROGEN
	name = "Hydrogen"
	molar_heat_capacity = 28.40
	molar_mass = 0.002
	flags = XGM_GAS_FUEL|XGM_GAS_FUSION_FUEL
	burn_product = GAS_STEAM
	symbol_html = "H<sub>2</sub>"
	symbol = "H2"

/singleton/xgm_gas/hydrogen/deuterium
	id = GAS_DEUTERIUM
	name = "Deuterium"
	molar_heat_capacity = 28.99
	molar_mass = 0.004
	symbol_html = "D"
	symbol = "D"

/singleton/xgm_gas/hydrogen/tritium
	id = GAS_TRITIUM
	name = "Tritium"
	molar_heat_capacity = 28.99
	molar_mass = 0.006
	symbol_html = "T"
	symbol = "T"

/singleton/xgm_gas/helium
	id = GAS_HELIUM
	name = "Helium"
	molar_heat_capacity = 20.77
	molar_mass = 0.004
	flags = XGM_GAS_FUSION_FUEL
	breathed_product = /datum/reagent/helium
	symbol_html = "He"
	symbol = "He"

/singleton/xgm_gas/argon
	id = GAS_ARGON
	name = "Argon"
	molar_heat_capacity = 20.36
	molar_mass = 0.039
	symbol_html = "Ar"
	symbol = "Ar"

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/singleton/xgm_gas/krypton
	id = GAS_KRYPTON
	name = "Krypton"
	molar_heat_capacity = 20.92
	molar_mass = 0.084
	symbol_html = "Kr"
	symbol = "Kr"

/singleton/xgm_gas/neon
	id = GAS_NEON
	name = "Neon"
	molar_heat_capacity = 20.60
	molar_mass = 0.02
	symbol_html = "Ne"
	symbol = "Ne"

/singleton/xgm_gas/xenon
	id = GAS_XENON
	name = "Xenon"
	molar_heat_capacity = 21.09
	molar_mass = 0.131
	breathed_product = /datum/reagent/nitrous_oxide/xenon
	symbol_html = "Xe"
	symbol = "Xe"

/singleton/xgm_gas/nitrodioxide
	id = GAS_NO2
	name = "Nitrogen Dioxide"
	tile_color = "#ca6409"
	molar_heat_capacity = 36.98
	molar_mass = 0.046
	flags = XGM_GAS_OXIDIZER
	breathed_product = /datum/reagent/toxin
	symbol_html = "NO<sub>2</sub>"
	symbol = "NO2"

/singleton/xgm_gas/nitricoxide
	id = GAS_NO
	name = "Nitric Oxide"

	molar_heat_capacity = 37.97
	molar_mass = 0.044
	flags = XGM_GAS_OXIDIZER
	symbol_html = "NO"
	symbol = "NO"

/singleton/xgm_gas/chlorine
	id = GAS_CHLORINE
	name = "Chlorine"
	tile_color = "#c5f72d"
	overlay_limit = 0.5
	molar_heat_capacity = 17.01
	molar_mass = 0.035
	flags = XGM_GAS_CONTAMINANT
	breathed_product = /datum/reagent/toxin/chlorine
	symbol_html = "Cl"
	symbol = "Cl"

/singleton/xgm_gas/vapor
	id = GAS_STEAM
	name = "Steam"
	tile_overlay = "generic"
	overlay_limit = 0.5
	molar_heat_capacity = 35.46
	molar_mass = 0.018
	breathed_product =     /datum/reagent/water
	condensation_product = /datum/reagent/water
	condensation_point =   308.15 // 35C. Dew point is ~20C but this is better for gameplay considerations.
	symbol_html = "H<sub>2</sub>O"
	symbol = "H2O"

/singleton/xgm_gas/sulfurdioxide
	id = GAS_SULFUR
	name = "Sulfur Dioxide"
	molar_heat_capacity = 42.82
	molar_mass = 0.064
	symbol_html = "SO<sub>2</sub>"
	symbol = "SO2"

/singleton/xgm_gas/ammonia
	id = GAS_AMMONIA
	name = "Ammonia"
	molar_heat_capacity = 37.04
	molar_mass = 0.017
	breathed_product = /datum/reagent/ammonia
	symbol_html = "NH<sub>3</sub>"
	symbol = "NH3"

/singleton/xgm_gas/carbon_monoxide
	id = GAS_CO
	name = "Carbon Monoxide"
	molar_heat_capacity = 29.18
	molar_mass = 0.028
	breathed_product = /datum/reagent/carbon_monoxide
	symbol_html = "CO"
	symbol = "CO"

/singleton/xgm_gas/boron
	id = GAS_BORON
	name = "Boron"
	molar_heat_capacity = 11.00
	molar_mass = 0.011
	flags = XGM_GAS_FUSION_FUEL
	breathed_product = /datum/reagent/toxin/boron
	symbol_html = "B"
	symbol = "B"
