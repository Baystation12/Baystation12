/datum/relation/friend
	name = "Friend"
	desc = "You have known the fellow for a while now, and you get along pretty well."
	incompatible = list("Enemy")

/datum/relation/friend/get_desc_string()
	return "[holder] and [other.holder] seem to be on good terms."

/datum/relation/enemy
	name = "Enemy"
	desc = "You have known the fellow for a while now, and you really can't stand each other."
	incompatible = list("Friend")

/datum/relation/enemy/get_desc_string()
	return "[holder] and [other.holder] do not get along well."

/datum/relation/had_crossed
	name = "Crossed"
	desc = "You have slighted them in the past, and they most likely hold a grudge against you."
	can_connect_to = list("Was Crossed")

/datum/relation/had_crossed/get_desc_string()
	return "Something has happened between [holder] and [other.holder] in the past, and [other.holder] is upset about it."

/datum/relation/was_crossed
	name = "Was Crossed"
	desc = "You have been slighted by them in the past, and you remember it."
	can_connect_to = list("Crossed")

/datum/relation/was_crossed/get_desc_string()
	return "Something has happened between [holder] and [other.holder] in the past, and [holder] is upset about it."

/datum/relation/rival
	name = "Rival"
	desc = "You are engaged in a constant struggle to show who's number one."

/datum/relation/rival/get_desc_string()
	return "[holder] and [other.holder] are fiercely competitive towards one another."

/datum/relation/rival/get_candidates()
	var/list/rest = ..()
	var/list/best = list()
	var/list/good = list()
	for(var/datum/relation/R in rest)
		if(!R.holder.assigned_job || !holder.assigned_job)
			continue
		if(R.holder.assigned_job == holder.assigned_job)
			best += R
		if(R.holder.assigned_job.department_flag & holder.assigned_job.department_flag)
			good += R
	if(best.len)
		return best
	else if (good.len)
		return good
	return rest

/datum/relation/ex
	name = "Ex"
	desc = "You used to be romantically involved, but not anymore."

/datum/relation/ex/get_desc_string()
	return "[holder] and [other.holder] used to be an item, but not anymore."

/datum/relation/spessnam
	name = "Served Together"
	desc = "You have crossed paths while in active military service."

/datum/relation/spessnam/get_desc_string()
	return "[holder] and [other.holder] served in military together at some point in the past."