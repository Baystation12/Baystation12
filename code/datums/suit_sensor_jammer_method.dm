/suit_sensor_jammer_method
	var/name
	var/energy_cost
	var/list/jammer_methods

/suit_sensor_jammer_method/New(var/holder, var/proc_call)
	..()
	for(var/jammer_method in jammer_methods)
		var/jammer_method_type = jammer_methods[jammer_method]
		jammer_methods[jammer_method] = new jammer_method_type(holder, proc_call)

/suit_sensor_jammer_method/dd_SortValue()
	return name

/suit_sensor_jammer_method/proc/enable()
	for(var/jammer_method in jammer_methods)
		crew_repository.add_modifier(jammer_method, jammer_methods[jammer_method])

/suit_sensor_jammer_method/proc/disable()
	for(var/jammer_method in jammer_methods)
		crew_repository.remove_modifier(jammer_method, jammer_methods[jammer_method])

/suit_sensor_jammer_method/random
	name = "Random - Minor"
	energy_cost = 0.5
	jammer_methods = list(
		/crew_sensor_modifier/general = /crew_sensor_modifier/general/jamming/random,
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/random,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/random,
		/crew_sensor_modifier/tracking = /crew_sensor_modifier/tracking/jamming/random
	)

/suit_sensor_jammer_method/random/moderate
	name = "Random - Moderate"
	energy_cost = 1
	jammer_methods = list(
		/crew_sensor_modifier/general = /crew_sensor_modifier/general/jamming/random/moderate,
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/random/moderate,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/random/moderate,
		/crew_sensor_modifier/tracking = /crew_sensor_modifier/tracking/jamming/random/moderate
	)

/suit_sensor_jammer_method/random/major
	name = "Random - Major"
	energy_cost = 2
	jammer_methods = list(
		/crew_sensor_modifier/general = /crew_sensor_modifier/general/jamming/random/major,
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/random/major,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/random/major,
		/crew_sensor_modifier/tracking = /crew_sensor_modifier/tracking/jamming/random/major
	)

/suit_sensor_jammer_method/healthy
	name = "Healthy"
	energy_cost = 2
	jammer_methods = list(
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/alive,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/healthy
	)

/suit_sensor_jammer_method/dead_brute
	name = "Dead - Brute"
	energy_cost = 2
	jammer_methods = list(
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/dead,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/brute
	)

/suit_sensor_jammer_method/dead_fire
	name = "Dead - Fire"
	energy_cost = 2
	jammer_methods = list(
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/dead,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/fire
	)

/suit_sensor_jammer_method/dead_oxy
	name = "Dead - Oxy"
	energy_cost = 2
	jammer_methods = list(
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/dead,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/oxy
	)

/suit_sensor_jammer_method/dead_tox
	name = "Dead - Tox"
	energy_cost = 2
	jammer_methods = list(
		/crew_sensor_modifier/binary = /crew_sensor_modifier/binary/jamming/dead,
		/crew_sensor_modifier/vital = /crew_sensor_modifier/vital/jamming/tox
	)

/suit_sensor_jammer_method/cap_off
	name = "Cap Data -  Off"
	energy_cost = 3
	jammer_methods = list(
		/crew_sensor_modifier/general = /crew_sensor_modifier/general/jamming/off
	)

/suit_sensor_jammer_method/cap_binary
	name = "Cap Data -  Binary"
	energy_cost = 2
	jammer_methods = list(
		/crew_sensor_modifier/general = /crew_sensor_modifier/general/jamming/binary
	)

/suit_sensor_jammer_method/cap_vital
	name = "Cap Data -  Vital"
	energy_cost = 1
	jammer_methods = list(
		/crew_sensor_modifier/general = /crew_sensor_modifier/general/jamming/vital
	)
