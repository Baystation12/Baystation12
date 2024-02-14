//OVERRIDE
/hook/startup/generateGasData()
	gas_data = new
	for(var/p in (subtypesof(/singleton/xgm_gas)))
		var/singleton/xgm_gas/gas = new p //avoid initial() because of potential New() actions

		if(gas.id in gas_data.gases)
			error("Duplicate gas id `[gas.id]` in `[p]`")

		gas_data.gases += gas.id
		gas_data.name[gas.id] = gas.name
		gas_data.specific_heat[gas.id] = gas.specific_heat
		gas_data.molar_mass[gas.id] = gas.molar_mass
		if(gas.overlay_limit)
			gas_data.overlay_limit[gas.id] = gas.overlay_limit
			gas_data.tile_overlay[gas.id] = gas.tile_overlay
			gas_data.tile_overlay_color[gas.id] = gas.tile_color
		gas_data.flags[gas.id] = gas.flags
		gas_data.burn_product[gas.id] = gas.burn_product

		gas_data.symbol_html[gas.id] = gas.symbol_html
		gas_data.symbol[gas.id] = gas.symbol

		if(!isnull(gas.condensation_product) && !isnull(gas.condensation_point))
			gas_data.condensation_points[gas.id] = gas.condensation_point
			gas_data.condensation_products[gas.id] = gas.condensation_product

		gas_data.breathed_product[gas.id] = gas.breathed_product
		gas_data.hidden_from_codex[gas.id] = gas.hidden_from_codex

	return 1
