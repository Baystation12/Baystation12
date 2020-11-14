/datum/relation/friend
	name = "Friend"
	desc = "You have known the fellow for a while now, and you get along pretty well."
	incompatible = list(/datum/relation/enemy)

/datum/relation/friend/get_desc_string()
	return "[holder] and [other.holder] seem to be on good terms."

/datum/relation/kid_friend
	name = "Childhood Friend"
	desc = "You have known them since you were both young."

/datum/relation/kid_friend/get_desc_string()
	return "[holder] and [other.holder] knew each other when they were both young."

/datum/relation/kid_friend/get_candidates()
	var/list/creche = ..()
	var/mob/living/carbon/human/holdermob = holder.current

	if(istype(holdermob))
		for(var/datum/relation/kid in creche)
			var/mob/living/carbon/human/kidmob = kid.holder.current
			if(!istype(kidmob))
				continue
			if(abs(holdermob.age - kidmob.age) > 3)
				creche -= kid		//No creepers please, it's okay if the pool is small.
				continue
			var/kidhome =    kidmob.get_cultural_value(TAG_HOMEWORLD)
			var/holderhome = holdermob.get_cultural_value(TAG_HOMEWORLD)
			if(kidhome && holderhome && kidhome != holderhome)
				creche -= kid		//No trans-galactic shennanigans either.
	return creche

/datum/relation/enemy
	name = "Enemy"
	desc = "You have known the fellow for a while now, and you really can't stand each other."
	incompatible = list(/datum/relation/friend, /datum/relation/so)

/datum/relation/enemy/get_desc_string()
	return "[holder] and [other.holder] do not get along well."

/datum/relation/had_crossed
	name = "Crossed"
	desc = "You have slighted them in the past, and they most likely hold a grudge against you."
	can_connect_to = list(/datum/relation/was_crossed)

/datum/relation/had_crossed/get_desc_string()
	return "Something has happened between [holder] and [other.holder] in the past, and [other.holder] is upset about it."

/datum/relation/was_crossed
	name = "Was Crossed"
	desc = "You have been slighted by them in the past, and you remember it."
	can_connect_to = list(/datum/relation/had_crossed)

/datum/relation/was_crossed/get_desc_string()
	return "Something has happened between [holder] and [other.holder] in the past, and [holder] is upset about it."

/datum/relation/nope
	name = "Avoiding"
	desc = "You or they have done something in the past, and you avoid them because of it."
	can_connect_to = list(/datum/relation/is_nope)

/datum/relation/nope/get_desc_string()
	return "[holder] avoids [other.holder], for some reason."

/datum/relation/is_nope
	name = "Had Unfortunate Experience"
	desc = "You or they have done something in the past, and they avoid you because of it."
	can_connect_to = list(/datum/relation/nope)

/datum/relation/is_nope/get_desc_string()
	return "[other.holder] avoids [holder], for some reason."

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

/datum/relation/lover
	name = "Lover"
	desc = "You have a thing going."
	incompatible = list(/datum/relation/xenolover, /datum/relation/ex)

/datum/relation/lover/get_desc_string()
	return "[holder] and [other.holder] seem to have a thing going."

/datum/relation/lover/get_candidates()
	var/list/lovers = ..()
	var/mob/living/carbon/human/holdermob = holder.current

	if(istype(holdermob))
		for(var/datum/relation/lover in lovers)
			var/mob/living/carbon/human/lovermob = lover.holder.current
			if(!istype(lovermob))
				continue
			var/loverspecies 	= lovermob.get_species()
			var/holderspecies 	= holdermob.get_species()
			if(loverspecies && holderspecies && loverspecies != holderspecies)
				lovers -= lover
	return lovers

/datum/relation/xenolover
	name = "Xenophilic Lover"
	desc = "You have a thing going, despite the fact you are different."
	incompatible = list(/datum/relation/lover, /datum/relation/ex)

/datum/relation/xenolover/get_desc_string()
	return "[holder] and [other.holder] seem to have a thing going, though they look alien to each other."

/datum/relation/xenolover/get_candidates()
	var/list/xlovers = ..()
	var/mob/living/carbon/human/holdermob = holder.current

	if(istype(holdermob))
		for(var/datum/relation/xlover in xlovers)
			var/mob/living/carbon/human/xlovermob = xlover.holder.current
			if(!istype(xlovermob))
				continue
			var/loverspecies 	= xlovermob.get_species()
			var/holderspecies 	= holdermob.get_species()
			if(loverspecies && holderspecies && loverspecies == holderspecies)
				xlovers -= xlover
	return xlovers

/datum/relation/xenolover/wholesome
	name = "Alien Friend"
	desc = "You have known the fellow for a while now, and differences only boost your friendship."
	incompatible = list(/datum/relation/enemy)

/datum/relation/xenolover/wholesome/get_desc_string()
	return "[holder] and [other.holder] seem to be on good terms, even if they differ from each other."

/datum/relation/so
	name = "Significiant Other"
	desc = "You are romantically involved."
	incompatible = list(/datum/relation/enemy, /datum/relation/ex)

/datum/relation/so/get_desc_string()
	return "[holder] and [other.holder] seem to be an item."

/datum/relation/ex
	name = "Ex"
	desc = "You used to be romantically involved, but not anymore."
	incompatible = list(/datum/relation/lover, /datum/relation/xenolover, /datum/relation/so)

/datum/relation/ex/get_desc_string()
	return "[holder] and [other.holder] used to be an item, but not anymore."

/datum/relation/spessnam
	name = "Served Together"
	desc = "You have crossed paths while in active military service."

/datum/relation/spessnam/get_candidates()
	var/list/warbuds = ..()
	var/list/branchmates = list()
	var/mob/living/carbon/human/holdermob = holder.current
	if(istype(holdermob) && GLOB.using_map && (GLOB.using_map.flags & MAP_HAS_BRANCH))
		for(var/datum/relation/buddy in warbuds)
			var/mob/living/carbon/human/buddymob = buddy.holder.current
			if(!istype(buddymob))
				continue
			if(holdermob.char_branch == buddymob.char_branch)
				branchmates += buddy
	return branchmates.len ? branchmates : warbuds

/datum/relation/spessnam/get_desc_string()
	return "[holder] and [other.holder] served in military together at some point in the past."
