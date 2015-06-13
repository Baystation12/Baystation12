/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (transforming)
		return
	if(!loc)
		return
	var/datum/gas_mixture/environment = loc.return_air()

	if(stat != DEAD)
		//Breathing, if applicable
		handle_breathing()

		//Mutations and radiation
		handle_mutations_and_radiation()

		. = 1

	//Handle temperature/pressure differences between body and environment
	if(environment)
		handle_environment(environment)

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	return
