/datum/admin_secret_item/admin_secret/bombing_list
	name = "Bombing List"

/datum/admin_secret_item/admin_secret/bombing_list/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = "<B>Bombing List</B>"
	for(var/l in bombers)
		dat += text("[l]<BR>")
	user << browse(dat, "window=bombers")
