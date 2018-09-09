/datum/map
	var/species_to_job_whitelist = list(/*/datum/species/vox = list(/datum/job/ai, /datum/job/cyborg)*/)
	var/species_to_job_blacklist = list()

// The white, and blacklist are type specific, any subtypes (of both species and jobs) have to be added explicitly
/datum/map/proc/is_species_job_restricted(var/datum/species/S, var/datum/job/J)
	if(!istype(S) || !istype(J))
		return TRUE

	//check the job itself first, before checking the map
	if(S.type in J.blacklisted_species)
		return TRUE
	if(J.whitelisted_species.len && !(S.type in J.whitelisted_species))
		return TRUE

	var/list/whitelist = species_to_job_whitelist[S.type]
	if(whitelist)
		return !(J.type in whitelist)

	var/list/blacklist = species_to_job_blacklist[S.type]
	if(blacklist)
		return (J.type in blacklist)

	return FALSE
