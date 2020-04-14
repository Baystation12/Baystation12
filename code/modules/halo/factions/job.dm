
/datum/job
	var/spawn_faction

/datum/job/proc/get_faction()
	return GLOB.factions_by_name[spawn_faction]

/datum/job/proc/get_arrivals_channel()
	var/datum/faction/F = get_faction()

	if(F)
		return F.get_arrivals_channel(src)

/datum/faction/proc/get_arrivals_channel(var/datum/job/J)
	return default_radio_channel

