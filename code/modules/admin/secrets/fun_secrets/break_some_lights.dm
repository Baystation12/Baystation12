/datum/admin_secret_item/fun_secret/break_some_lights
	name = "Break Some Lights"

/datum/admin_secret_item/fun_secret/break_some_lights/execute(mob/user)
	. = ..()
	if(.)
		lightsout(1,2)
