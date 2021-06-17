/datum/species/proc/attempt_grab(var/mob/living/carbon/human/grabber, var/atom/movable/target, var/grab_type)
	if(grabber != target)
		grabber.visible_message(SPAN_DANGER("[grabber] attempted to grab \the [target]!"))
	return grabber.make_grab(grabber, target, grab_type)
