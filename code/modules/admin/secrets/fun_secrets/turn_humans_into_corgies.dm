/datum/admin_secret_item/fun_secret/turn_humans_into_corgies
	name = "Turn All Humans Into Corgies"

/datum/admin_secret_item/fun_secret/turn_humans_into_corgies/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/mob/living/carbon/human/H in SSmobs.mob_list)
		addtimer(CALLBACK(H, /mob/living/carbon/human/.proc/corgize), 0)
