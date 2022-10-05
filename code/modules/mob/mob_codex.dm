/mob/get_mechanics_info()
	. = ..()
	if (mob_flags && MOB_FLAG_NO_PULL)
		. += "<p>They cannot be pulled, even if not anchored.</p>"
