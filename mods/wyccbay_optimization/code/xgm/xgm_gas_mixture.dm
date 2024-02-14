//OVERRIDE

//Merges all the gas from another mixture into this one.  Respects group_multipliers and adjusts temperature correctly.
//Does not modify giver in any way.
/datum/gas_mixture/merge(datum/gas_mixture/giver)
	if(!giver)
		return

	if(abs(temperature-giver.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity()
		var/giver_heat_capacity = giver.heat_capacity()
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (giver.temperature * giver_heat_capacity + temperature*self_heat_capacity) / combined_heat_capacity

	if((group_multiplier != 1)||(giver.group_multiplier != 1))
		for(var/g in giver.gas)
			gas[g] += giver.gas[g] * giver.group_multiplier / group_multiplier
	else
		for(var/g in giver.gas)
			gas[g] += giver.gas[g]

	update_values()

//Rechecks the gas_mixture and adjusts the graphic list if needed.
//Two lists can be passed by reference if you need know specifically which graphics were added and removed.
/datum/gas_mixture/check_tile_graphic(list/graphic_add = null, list/graphic_remove = null)
	for(var/obj/gas_overlay/gas_overlay in graphic)
		if(istype(gas_overlay, /obj/gas_overlay/heat))
			continue

		if(istype(gas_overlay, /obj/gas_overlay/cold))
			continue

		if(gas[gas_overlay.gas_id] <= gas_data.overlay_limit[gas_overlay.gas_id])
			LAZYADD(graphic_remove, gas_overlay)

	var/should_generate_temp_overlay = FALSE
	for(var/gas_id in gas_data.overlay_limit)
		//Overlay isn't applied for this gas, check if it's valid and needs to be added.
		if(gas[gas_id] > gas_data.overlay_limit[gas_id])
			should_generate_temp_overlay = TRUE
			var/tile_overlay = get_tile_overlay(gas_id)
			if(!(tile_overlay in graphic))
				LAZYADD(graphic_add, tile_overlay)
	. = FALSE

	if(should_generate_temp_overlay)
		var/heat_overlay = get_tile_overlay(GAS_HEAT)
		//If it's hot add something
		if(temperature >= CARBON_LIFEFORM_FIRE_RESISTANCE)
			if(!(heat_overlay in graphic))
				LAZYADD(graphic_add, heat_overlay)
		else if (heat_overlay in graphic)
			LAZYADD(graphic_remove, heat_overlay)

		var/cold_overlay = get_tile_overlay(GAS_COLD)
		if(temperature <= FOGGING_TEMPERATURE && (return_pressure() >= (ONE_ATMOSPHERE / 4)))
			if(!(cold_overlay in graphic))
				LAZYADD(graphic_add, cold_overlay)
		else if (cold_overlay in graphic)
			LAZYADD(graphic_remove, cold_overlay)

	//Apply changes
	if(graphic_add && length(graphic_add))
		graphic |= graphic_add
		. = TRUE

	if(graphic_remove && length(graphic_remove))
		graphic -= graphic_remove
		. = TRUE

	if(!length(graphic))
		return .

	var/pressure_mod = clamp(return_pressure() / ONE_ATMOSPHERE, 0, 2)
	for(var/obj/gas_overlay/overlay in graphic)
		if(istype(overlay, /obj/gas_overlay/heat)) //Heat based
			var/new_alpha = clamp(max(125, 255 * ((temperature - CARBON_LIFEFORM_FIRE_RESISTANCE) / CARBON_LIFEFORM_FIRE_RESISTANCE * 4)), 125, 255)
			if(new_alpha != overlay.alpha)
				overlay.update_alpha_animation(new_alpha)
			continue

		if(istype(overlay, /obj/gas_overlay/cold))
			var/new_alpha = clamp(max(125, 200 * (1 - ((temperature - MAX_FOG_TEMPERATURE) / (FOGGING_TEMPERATURE - MAX_FOG_TEMPERATURE)))), 125, 200)
			if(new_alpha != overlay.alpha)
				overlay.update_alpha_animation(new_alpha)
			continue

		var/concentration_mod = clamp(gas[overlay.gas_id] / total_moles, 0.1, 1)
		var/new_alpha = min(230, round(pressure_mod * concentration_mod * 180, 5))
		if(new_alpha != overlay.alpha)
			overlay.update_alpha_animation(new_alpha)
