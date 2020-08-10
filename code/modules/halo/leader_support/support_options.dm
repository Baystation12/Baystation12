
/datum/support_option
	var/name = "option"
	var/desc = "description"
	var/rank_required = 0 //each leader type role should have a variable defining this, then we pull and check it here.
	var/cooldown_inflict = 1 MINUTE

//Return 1 if successful, 0 if otherwise
/datum/support_option/proc/activate_option(var/turf/origin,var/mob/living/activator)
	return 1