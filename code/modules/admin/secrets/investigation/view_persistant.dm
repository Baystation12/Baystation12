/datum/admin_secret_item/investigation/view_persistant
	name = "View Persistant Data"

/datum/admin_secret_item/investigation/view_persistant/execute(var/mob/user)
	. = ..()
	if(.)
		SSpersistence.show_info(user)