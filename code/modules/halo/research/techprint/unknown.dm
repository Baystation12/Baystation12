
/datum/techprint/unknown
	name = "Alien Analysis"
	desc = "Analyze strange alien technology."

/datum/techprint/unknown/can_destruct_obj(var/obj/item/I)
	//deconstruct anything and it might reveal a hidden techprint
	return TRUE
/
/datum/techprint/unknown/GetPercent()
	return 0

/datum/techprint/unknown/obj_destructed(var/obj/item/I)
	//return if there are any hidden things unlocked by it
	return GLOB.techprints_hidden[I.type]

/datum/techprint/unknown/UpdateReqsString()
	reqs_string = "None"

/datum/techprint/unknown/UpdateDesignsString()
	designs_string = "Unknown"

/datum/techprint/unknown/UpdateConsumablesString()
	reqs_string = "Anything"

/datum/techprint/unknown/consumables_satisfied()
	return FALSE
