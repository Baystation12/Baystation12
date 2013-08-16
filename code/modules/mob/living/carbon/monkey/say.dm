/mob/living/carbon/monkey/say(var/message)
	if (silent)
		return
	else
		return ..()
