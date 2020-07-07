
/datum/techprint
	var/consumables_string
	var/reqs_string
	var/designs_string

/datum/techprint/proc/GetConsumablesString()
	if(!consumables_string)
		UpdateConsumablesString()
	return consumables_string

/datum/techprint/proc/GetPercent()
	if(completed)
		return 100

	//does this have a timer?
	if(ticks_max)
		if(consumables_max)
			//mix of consumables and timer
			var/result = 0

			//half weight from the timer
			result += 50 * (ticks_current / ticks_max)

			//half weight from consumables
			result += 50 * (consumables_current / consumables_max)

			return round(result)

		//only return the timer progress
		return round(100 * ticks_current / ticks_max)

	//does this have consumables?
	if(consumables_max)
		//only return the consumable progress
		return round(100 * consumables_current / consumables_max)

	to_debug_listeners("TECH ERROR: ui unable to determine percent for [src.type]")
	//return "ERR-NO-PERCENT"

/datum/techprint/proc/GetReqsString()
	if(!reqs_string)
		UpdateReqsString()
	return reqs_string

/datum/techprint/proc/GetDesignsString()
	if(!designs_string)
		UpdateDesignsString()
	return designs_string
