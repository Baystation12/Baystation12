/datum/admin_secret_item/fun_secret/make_all_areas_powered
	name = "Make All Areas Powered"

/datum/admin_secret_item/fun_secret/make_all_areas_powered/execute(var/mob/user)
	. = ..()
	if(.)
		power_restore()
