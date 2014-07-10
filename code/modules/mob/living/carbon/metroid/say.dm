/mob/living/carbon/slime/say(var/message)
	if (silent)
		return
	else
		return ..()

/mob/living/carbon/slime/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "telepathically asks";
	else if (ending == "!")
		return "telepathically cries";

	return "telepathically chirps";

/mob/living/carbon/slime/say_understands(var/other)
	if (istype(other, /mob/living/carbon/slime))
		return 1
	return ..()

