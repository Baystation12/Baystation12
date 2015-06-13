/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (transforming)
		return
	if(!loc)
		return
	var/datum/gas_mixture/environment = loc.return_air()

	if(stat != DEAD)
		. = 1

	return .
