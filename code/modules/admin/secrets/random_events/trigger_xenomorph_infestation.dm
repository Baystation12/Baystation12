/datum/admin_secret_item/random_event/trigger_xenomorph_infestation
	name = "Trigger a Xenophage Infestation"

/datum/admin_secret_item/random_event/trigger_xenomorph_infestation/execute(var/mob/user)
	. = ..()
	if(.)
		return GLOB.xenomorphs.attempt_random_spawn()
