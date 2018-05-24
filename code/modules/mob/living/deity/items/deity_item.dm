/datum/deity_item
	var/name
	var/desc
	var/base_cost = 1
	var/category
	var/level = 0
	var/max_level = 0
	var/list/requirements //Name of item = level of item

/datum/deity_item/proc/can_buy(var/mob/living/deity/D)
	if(max_level && level == max_level)
		return FALSE
	var/cost = get_cost(D)
	if(cost && D.power < cost)
		return FALSE
	if(requirements && requirements.len)
		for(var/name in requirements)
			if(!D.has_item(name,requirements[name]))
				return FALSE
	return TRUE

/datum/deity_item/proc/buy(var/mob/living/deity/D)
	D.adjust_power(-get_cost(D))
	level++

/datum/deity_item/proc/get_cost(var/mob/living/deity/D)
	return base_cost


/datum/deity_item/proc/print_level()
	return "[level][max_level ? "/[max_level]" : ""]"

/datum/deity_item/proc/print_requirements()
	if(!requirements)
		return "N/A"
	. = ""
	for(var/l in requirements)
		. += "[l] [requirements[l]]<br>"