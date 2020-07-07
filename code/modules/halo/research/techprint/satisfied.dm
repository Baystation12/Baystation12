
/datum/techprint/proc/ticks_satisfied()
	return ticks_current >= ticks_max

/datum/techprint/proc/prereqs_satisfied(var/datum/computer_file/research_db/owner_db)

	//require at least one of these techs
	if(tech_req_one.len)
		var/success = FALSE
		for(var/check_type in tech_req_one)
			var/datum/techprint/pre_req = owner_db.techprints_by_type[check_type]
			if(pre_req && pre_req.completed)
				success = TRUE
				break

		if(!success)
			//tech_reached = FALSE
			return FALSE

	//require all of these techs
	if(tech_req_all.len)
		for(var/check_type in tech_req_all)
			var/datum/techprint/pre_req = owner_db.techprints_by_type[check_type]
			if(!pre_req || !pre_req.completed)
				//tech_reached = FALSE
				return FALSE

	//tech_reached = TRUE
	return TRUE

/datum/techprint/proc/consumables_satisfied()
	if(required_reagents.len)
		return FALSE

	if(required_materials.len)
		return FALSE

	if(required_objs.len)
		return FALSE

	return TRUE
