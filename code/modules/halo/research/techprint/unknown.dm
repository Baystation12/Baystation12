
/datum/techprint/unknown
	name = "Alien Analysis"
	desc = "Analyze strange alien technology to potentially find a hidden techprint."

/datum/techprint/unknown/can_destruct_obj(var/obj/item/I)
	//deconstruct anything and it might reveal a hidden techprint
	return TRUE
/
/datum/techprint/unknown/GetPercent()
	return 0

/datum/techprint/unknown/obj_destructed(var/obj/item/I)
	//return if there are any hidden things unlocked by it
	var/list/results = list()
	. = results
	for(var/check_type in GLOB.techprints_hidden)
		if(ispath(I.type, check_type))
			results += GLOB.techprints_hidden[check_type]

/datum/techprint/unknown/UpdateReqsString()
	reqs_string = "None"

/datum/techprint/unknown/UpdateDesignsString()
	designs_string = "Unknown"

/datum/techprint/unknown/UpdateConsumablesString()
	consumables_string = "Anything"

/datum/techprint/unknown/consumables_satisfied()
	return FALSE
