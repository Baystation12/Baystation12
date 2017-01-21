/datum/admin_secret_item/fun_secret/only_one
	name = "There Can Be Only One"

/datum/admin_secret_item/fun_secret/only_one/execute(var/mob/user)
	. = ..()
	if(.)
		only_one()
