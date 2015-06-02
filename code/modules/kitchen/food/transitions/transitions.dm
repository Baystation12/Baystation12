/datum/food_transition
	var/input_type
	var/output_type
	var/cooking_message
	var/cooking_time = 10
	var/cooking_method
	var/list/req_reagents = list()
	var/req_container
	var/priority = 1

/datum/food_transition/proc/matches_input_type(var/obj/item/I, var/obj/item/container)
	if(input_type)
		if(!I || !istype(I, input_type))
			return 0
	if(req_container)
		if(!container || !istype(container, req_container))
			return 0
	return 1

/datum/food_transition/proc/get_output_product(var/obj/item/source)
	return new output_type(source.loc)

/datum/food_transition/proc/check_for_reagents(var/datum/reagents/available_reagents)
	var/list/temp_reagents = req_reagents.Copy()

	if(req_reagents.len)
		if(isnull(available_reagents))
			return 0
		for(var/datum/reagent/R in available_reagents.reagent_list)
			if(temp_reagents[R.id] > 0)
				temp_reagents[R.id] -= R.volume

	var/overfilled
	for(var/reagent_id in temp_reagents)
		if(temp_reagents[reagent_id] > 0)
			return 0
		else if (temp_reagents[reagent_id] < 0)
			overfilled = 1
	return (overfilled ? 2 : 1)
