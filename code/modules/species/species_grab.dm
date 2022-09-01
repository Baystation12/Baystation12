/datum/species/proc/attempt_grab(mob/living/carbon/human/grabber, atom/movable/target, grab_type)
	if(grabber != target)
		grabber.visible_message(SPAN_DANGER("[grabber] attempted to grab \the [target]!"))
	return grabber.make_grab(grabber, target, grab_type)
