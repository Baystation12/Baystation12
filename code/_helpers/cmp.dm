/proc/cmp_crew_sensor_modifier(var/crew_sensor_modifier/a, var/crew_sensor_modifier/b)
	return b.priority - a.priority

/proc/cmp_appearance_data(var/datum/appearance_data/a, var/datum/appearance_data/b)
	return b.priority - a.priority
