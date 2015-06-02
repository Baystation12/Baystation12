#define TEMP_CHANGE 5

/obj/machinery/kitchen/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		update_use_power(0)
		return
	handle_heat()

/obj/machinery/kitchen/proc/apply_heat(var/obj/item/weapon/reagent_containers/kitchen/food, var/temperature)
	if(!istype(food))
		return 0
	if(temperature < 60)
		return
	food.recieve_heat((temperature - 60) * 0.1)
	return 1

/obj/machinery/kitchen/proc/handle_heat()
	if(stat & (BROKEN|NOPOWER))
		return 0
	if(use_power != 2)
		return 0
	return 1

/obj/machinery/kitchen/stove/handle_heat()
	var/powered = ..()
	for(var/burner in burners_temperature)
		// Update heat.
		if(powered && burners_temperature[burner] < burners_target_temp[burner])
			burners_temperature[burner] += TEMP_CHANGE
		else
			burners_temperature[burner] -= TEMP_CHANGE
		burners_temperature[burner] = min(max_temp,max(min_temp,burners_temperature[burner]))

		// Apply to food.
		var/obj/item/I = burner_contents[burner]
		if(I && istype(I))
			apply_heat(I, burners_temperature[burner])
	update_icon()

/obj/machinery/kitchen/oven/handle_heat()

	// Update internal temperature.
	if(..())
		if(internal_temp < target_temp)
			internal_temp += TEMP_CHANGE
		else if(internal_temp > target_temp)
			internal_temp -= TEMP_CHANGE
	else if(internal_temp > min_temp) //Todo check ambient temperature.
		internal_temp -= TEMP_CHANGE

	// An open oven will lose heat rapidly.
	if(open)
		internal_temp = round(internal_temp*0.95)
	internal_temp = min(max_temp,max(min_temp,internal_temp))

	// Apply heat to food.
	apply_heat(food_inside, internal_temp)
	update_icon()

#undef TEMP_CHANGE