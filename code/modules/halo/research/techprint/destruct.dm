
/datum/techprint/proc/obj_destructed(var/obj/item/I)
	. = FALSE

	//only gain 1 thing per item
	if(check_objs(I, TRUE))
		. = TRUE

	else if(check_materials(I, TRUE))
		. = TRUE

	else if(check_reagents(I, TRUE))
		. = TRUE

	if(.)
		//should we update the ui?
		UpdateConsumablesString()

/datum/techprint/proc/can_destruct_obj(var/obj/item/I)
	//will this item help us progress?
	. = FALSE

	if(check_objs(I))
		return TRUE

	if(check_materials(I))
		return TRUE

	if(check_reagents(I))
		return TRUE
