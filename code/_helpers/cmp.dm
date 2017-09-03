/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_crew_sensor_modifier(var/crew_sensor_modifier/a, var/crew_sensor_modifier/b)
	return b.priority - a.priority

/proc/cmp_appearance_data(var/datum/appearance_data/a, var/datum/appearance_data/b)
	return b.priority - a.priority

/proc/cmp_follow_holder(var/datum/follow_holder/a, var/datum/follow_holder/b)
	if(a.sort_order == b.sort_order)
		return sorttext(b.get_name(), a.get_name())

	return a.sort_order - b.sort_order

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	var/a_init_order = ispath(a) ? initial(a.init_order) : a.init_order
	var/b_init_order = ispath(b) ? initial(b.init_order) : b.init_order

	return b_init_order - a_init_order	//uses initial() so it can be used on types

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority
