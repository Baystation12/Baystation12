/datum/chorus_resource
	var/name = "resource"
	var/name_color = COLOR_WHITE
	var/amount = 25

/datum/chorus_resource/proc/has_amount(var/amt)
	return amt <= get_amount()

/datum/chorus_resource/proc/use_amount(var/amt)
	if(amt <= amount)
		amount -= amt
		return TRUE
	return FALSE

/datum/chorus_resource/proc/get_amount()
	return amount

/datum/chorus_resource/proc/add_amount(var/amt)
	amount += amt
	return TRUE

/datum/chorus_resource/proc/printed_cost(var/minimum = FALSE)
	return "<span style=\"color: [name_color];\">[minimum ? copytext_char(name, 1, 2) : name]</span>"
