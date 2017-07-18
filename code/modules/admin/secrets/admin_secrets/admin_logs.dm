/datum/admin_secret_item/admin_secret/admin_logs
	name = "Admin Logs"

/datum/admin_secret_item/admin_secret/admin_logs/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = "<B>Admin Log<HR></B>"
	for(var/l in admin_log)
		dat += "<li>[l]</li>"
	if(!admin_log.len)
		dat += "No-one has done anything this round!"
	user << browse(dat, "window=admin_log")
