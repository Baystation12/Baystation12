/datum/species/proc/attempt_grab(var/mob/living/carbon/human/grabber, var/atom/movable/target, var/grab_type)
	grabber.visible_message("<span class='danger'>[grabber] attempted to grab \the [target]!</span>")
	return grabber.make_grab(grabber, target, grab_type)
