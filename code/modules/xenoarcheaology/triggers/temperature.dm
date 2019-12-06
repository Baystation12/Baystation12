/datum/artifact_trigger/temperature
	name = "specific temperature range"
	toggle = FALSE
	var/min_temp
	var/max_temp

/datum/artifact_trigger/temperature/New()
	if(isnull(min_temp) && isnull(max_temp))
		min_temp = rand(T0C - 100, T0C + 200)
		max_temp = min_temp + rand(10, 30)

/datum/artifact_trigger/temperature/on_gas_exposure(datum/gas_mixture/gas)
	return gas.temperature >= min_temp && gas.temperature <= max_temp

/datum/artifact_trigger/temperature/on_hit(obj/O, mob/user)
	return O.temperature >= min_temp && O.temperature <= max_temp

/datum/artifact_trigger/temperature/cold
	name = "low temperature"

/datum/artifact_trigger/temperature/cold/New()
	min_temp = -INFINITY
	max_temp = rand(T0C - 100, T0C)

/datum/artifact_trigger/temperature/heat
	name = "high temperature"

/datum/artifact_trigger/temperature/heat/New()
	min_temp = rand(T0C + 20, T0C + 300)
	max_temp = INFINITY

/datum/artifact_trigger/temperature/heat/on_hit(obj/O, mob/user)
	. = ..()
	if(!. && isflamesource(O))
		return TRUE

/datum/artifact_trigger/temperature/heat/on_explosion(severity)
	return TRUE