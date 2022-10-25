/datum/suit_sensor_jammer_method
	var/name
	var/energy_cost
	var/list/jammer_methods

/datum/suit_sensor_jammer_method/New(holder, proc_call)
	..()
	for(var/jammer_method in jammer_methods)
		var/jammer_method_type = jammer_methods[jammer_method]
		jammer_methods[jammer_method] = new jammer_method_type(holder, proc_call)

/datum/suit_sensor_jammer_method/dd_SortValue()
	return name

/datum/suit_sensor_jammer_method/proc/enable()
	for(var/jammer_method in jammer_methods)
		crew_repository.add_modifier(jammer_method, jammer_methods[jammer_method])

/datum/suit_sensor_jammer_method/proc/disable()
	for(var/jammer_method in jammer_methods)
		crew_repository.remove_modifier(jammer_method, jammer_methods[jammer_method])

/datum/suit_sensor_jammer_method/random
	name = "Random - Minor"
	energy_cost = 0.5
	jammer_methods = list(
		/datum/crew_sensor_modifier/general = /datum/crew_sensor_modifier/general/jamming/random,
		/datum/crew_sensor_modifier/binary = /datum/crew_sensor_modifier/binary/jamming/random,
		/datum/crew_sensor_modifier/vital = /datum/crew_sensor_modifier/vital/jamming/random,
		/datum/crew_sensor_modifier/tracking = /datum/crew_sensor_modifier/tracking/jamming/random
	)

/datum/suit_sensor_jammer_method/random/moderate
	name = "Random - Moderate"
	energy_cost = 1
	jammer_methods = list(
		/datum/crew_sensor_modifier/general = /datum/crew_sensor_modifier/general/jamming/random/moderate,
		/datum/crew_sensor_modifier/binary = /datum/crew_sensor_modifier/binary/jamming/random/moderate,
		/datum/crew_sensor_modifier/vital = /datum/crew_sensor_modifier/vital/jamming/random/moderate,
		/datum/crew_sensor_modifier/tracking = /datum/crew_sensor_modifier/tracking/jamming/random/moderate
	)

/datum/suit_sensor_jammer_method/random/major
	name = "Random - Major"
	energy_cost = 2
	jammer_methods = list(
		/datum/crew_sensor_modifier/general = /datum/crew_sensor_modifier/general/jamming/random/major,
		/datum/crew_sensor_modifier/binary = /datum/crew_sensor_modifier/binary/jamming/random/major,
		/datum/crew_sensor_modifier/vital = /datum/crew_sensor_modifier/vital/jamming/random/major,
		/datum/crew_sensor_modifier/tracking = /datum/crew_sensor_modifier/tracking/jamming/random/major
	)

/datum/suit_sensor_jammer_method/healthy
	name = "Healthy"
	energy_cost = 2
	jammer_methods = list(
		/datum/crew_sensor_modifier/binary = /datum/crew_sensor_modifier/binary/jamming/alive,
		/datum/crew_sensor_modifier/vital = /datum/crew_sensor_modifier/vital/jamming/healthy
	)

/datum/suit_sensor_jammer_method/dead
	name = "Dead"
	energy_cost = 2
	jammer_methods = list(
		/datum/crew_sensor_modifier/binary = /datum/crew_sensor_modifier/binary/jamming/dead,
		/datum/crew_sensor_modifier/vital = /datum/crew_sensor_modifier/vital/jamming/dead
	)

/datum/suit_sensor_jammer_method/cap_off
	name = "Cap Data - Off"
	energy_cost = 3
	jammer_methods = list(
		/datum/crew_sensor_modifier/general = /datum/crew_sensor_modifier/general/jamming/off
	)

/datum/suit_sensor_jammer_method/cap_binary
	name = "Cap Data - Binary"
	energy_cost = 2
	jammer_methods = list(
		/datum/crew_sensor_modifier/general = /datum/crew_sensor_modifier/general/jamming/binary
	)

/datum/suit_sensor_jammer_method/cap_vital
	name = "Cap Data - Vital"
	energy_cost = 1
	jammer_methods = list(
		/datum/crew_sensor_modifier/general = /datum/crew_sensor_modifier/general/jamming/vital
	)
