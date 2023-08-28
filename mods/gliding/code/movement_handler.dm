/datum/movement_handler/mob/delay
	VAR_PROTECTED/delay = 1

/datum/movement_handler/mob/delay/proc/UpdateGlideSize()
	host.set_glide_size(DELAY2GLIDESIZE(delay))

/datum/movement_handler/delay/proc/UpdateGlideSize()
	host.set_glide_size(DELAY2GLIDESIZE(delay))
