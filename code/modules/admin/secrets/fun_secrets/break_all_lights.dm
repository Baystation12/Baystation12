/datum/admin_secret_item/fun_secret/break_all_lights
	name = "Break All Lights"

/datum/admin_secret_item/fun_secret/make_all_areas_powered/execute(var/mob/user)
	. = ..()
	if(.)
		lightsout(0,0)
