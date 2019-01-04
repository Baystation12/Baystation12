SUBSYSTEM_DEF(statistics)
	name = "Statistics"
	flags = SS_NO_FIRE | SS_NO_INIT
	var/list/values = list()
	var/list/value_details = list()

/datum/controller/subsystem/statistics/proc/get_field(var/field)
	return values[field]

/datum/controller/subsystem/statistics/proc/set_field(var/field, var/value)
	values[field] = value

/datum/controller/subsystem/statistics/proc/add_field(var/field, var/value)
	if(isnull(values[field]))
		set_field(field, value)
	else
		values[field] += value

/datum/controller/subsystem/statistics/proc/get_field_details(var/field)
	return jointext(value_details[field], "<br>")

/datum/controller/subsystem/statistics/proc/set_field_details(var/field, var/details)
	value_details[field] = list(details)

/datum/controller/subsystem/statistics/proc/add_field_details(var/field, var/details)
	if(isnull(value_details[field]))
		set_field_details(field, details)
	else
		value_details[field] += details
