/datum/admin_secret_item/fun_secret/turn_humans_into_monkeys
	name = "Turn All Humans Into Monkeys"

/datum/admin_secret_item/fun_secret/turn_humans_into_monkeys/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		spawn(0)
			H.monkeyize()
