/datum/codex_category/gases
	name = "Gases"
	desc = "Notable gases."

/datum/codex_category/gases/Initialize()
	for(var/gas in gas_data.gases)
		if(gas_data.hidden_from_codex[gas])
			continue

		var/list/gas_info = list()
		gas_info+= "Specific heat: [gas_data.specific_heat[gas]] J/(mol*K)."
		gas_info+= "Molar mass: [gas_data.molar_mass[gas]] kg/mol."
		if(gas_data.flags[gas] & XGM_GAS_FUEL)
			gas_info+= "It is flammable."
			gas_info+= "Produces [gas_data.name[gas_data.burn_product[gas]]] when burned."
		if(gas_data.flags[gas] & XGM_GAS_OXIDIZER)
			gas_info+= "It is an oxidizer, required to sustain fire."
		if(gas_data.flags[gas] & XGM_GAS_CONTAMINANT)
			gas_info+= "It contaminates exposed clothing with residue."
		if(gas_data.flags[gas] & XGM_GAS_FUSION_FUEL)
			gas_info+= "It can be used as fuel in a fusion reaction."
		if(gas_data.condensation_points[gas])
			var/datum/reagent/product = gas_data.condensation_products[gas]
			gas_info+= "At [gas_data.condensation_points[gas]] K it condenses into [initial(product.name)]."
		var/datum/codex_entry/entry = new(_display_name = lowertext(trim("[gas_data.name[gas]] (gas)")), _mechanics_text = jointext(gas_info, "<br>"))
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name
	..()