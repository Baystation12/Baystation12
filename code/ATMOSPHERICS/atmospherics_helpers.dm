//Calculates the amount of power needed to move one mole from source to sink.
/obj/machinery/atmospherics/proc/calculate_specific_power(datum/gas_mixture/source, datum/gas_mixture/sink)
	//Calculate the amount of energy required
	var/air_temperature = (sink.temperature > 0)? sink.temperature : source.temperature
	var/specific_entropy = sink.specific_entropy() - source.specific_entropy()	//environment is gaining moles, air_contents is loosing
	var/specific_power = 0	// W/mol
	
	//If specific_entropy is < 0 then transfer_moles is limited by how powerful the pump is
	if (specific_entropy < 0)
		specific_power = -specific_entropy*air_temperature		//how much power we need per mole
	
	return specific_power

//This proc handles power usages so that we only have to call use_power() when the pump is loaded but not at full load. 
/obj/machinery/atmospherics/proc/handle_pump_power_draw(var/usage_amount)
	if (usage_amount > active_power_usage - 5)
		update_use_power(2)
	else
		update_use_power(1)
		
		if (usage_amount > idle_power_usage)
			use_power(round(usage_amount))	//in practice it's pretty rare that we will get here, so calling use_power() is alright.

