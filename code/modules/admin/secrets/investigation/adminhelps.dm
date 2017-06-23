/datum/admin_secret_item/investigation/adminhelps
	name = "Adminhelps"
	var/list/users
	var/content

/datum/admin_secret_item/investigation/adminhelps/New()
	..()
	users = list()
	adminhelp_repository.listen(src)
	build_content()

/datum/admin_secret_item/investigation/adminhelps/CanUseTopic(var/mob/user, var/datum/topic_state/state, var/list/href_list)
	if(href_list["close"]) // we ALWAYS want to close, even if we've been deadmined or any other weirdness
		return STATUS_INTERACTIVE
	return ..()

/datum/admin_secret_item/investigation/adminhelps/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["close"])
		users -= usr.client
	else if(href_list["take"])
		var/datum/adminhelp/AH = locate(href_list["take"])
		if(!AH)
			return
		AH.take(usr.client)
	else if(href_list["dismiss"])
		var/datum/adminhelp/AH = locate(href_list["dismiss"])
		if(!AH)
			return
		AH.dismiss()
	else if(href_list["fwd"])
		var/datum/adminhelp/AH = locate(href_list["fwd"])
		if(!AH)
			return
		var/client/target = input("Who would you like to forward to?") as null|anything in admins
		if(target)
			AH.forward(target)
	else if(href_list["free"])
		var/datum/adminhelp/AH = locate(href_list["free"])
		if(!AH)
			return
		AH.release()

/datum/admin_secret_item/investigation/adminhelps/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	users += user.client
	update_user(user)

/datum/admin_secret_item/investigation/adminhelps/proc/build_options(var/datum/adminhelp/AH, var/take = 1, var/free = 0, var/fwd = 1, var/dismiss = 1)
	var/options = list()
	if(take)
		options += "<a href='?src=\ref[src];take=\ref[AH]'>TAKE</a>"
	if(free)
		options += "<a href='?src=\ref[src];free=\ref[AH]'>FREE</a>"
	if(fwd)
		options += "<a href='?src=\ref[src];fwd=\ref[AH]'>FWD</a>"
	if(dismiss)
		options += "<a href='?src=\ref[src];dismiss=\ref[AH]'>X</a>"

	return jointext(options,null)

/datum/admin_secret_item/investigation/adminhelps/proc/build_entry(var/datum/adminhelp/AH, var/disposition, var/color = "", var/take = 1, var/free = 0, var/fwd = 1, var/dismiss = 1)
	var/entry = list()
	entry += "<tr bgcolor='[color]'><td>[AH.station_time]</td><td>[AH.sender.key_name(FALSE,rank=FALSE)]</td><td>[disposition] [build_options(AH, take, free, fwd, dismiss)]</td></tr>"
	entry += "<tr bgcolor='[color]'><td colspan=3>[AH.msg]</td></tr>"

	return jointext(entry,null)

/datum/admin_secret_item/investigation/adminhelps/proc/build_content()
	var/content = list()
	content += "<table border='1' style='width:100%;border-collapse:collapse;'>"
	content += "<tr><th style='text-align:left;'>Time</th><th style='text-align:left;'>Sender</th><th></th></tr>"
	for (var/datum/adminhelp/AH in adminhelp_repository.adminhelps_available)
		var/disposition = "Available"
		content += build_entry(AH, disposition, "red")
	for (var/datum/adminhelp/AH in adminhelp_repository.adminhelps_taken)
		var/disposition = "Taken([AH.handler.ckey])"
		content += build_entry(AH, disposition, "green", take = 0, free = 1)
	for (var/datum/adminhelp/AH in adminhelp_repository.adminhelps_archive)
		var/disposition = "Ignored"
		if(AH.handler)
			disposition = "Handled([AH.handler.key_name(FALSE,name=FALSE,rank=FALSE,check_if_offline=FALSE)])"
		content += build_entry(AH, disposition, "blue", take = 0, fwd = 0, dismiss = 0)
	content += "</table>"
	src.content = jointext(content,null)

/datum/admin_secret_item/investigation/adminhelps/proc/update_user(var/mob/user)
	if(isclient(user))
		var/client/C = user
		user = C.mob
	var/datum/browser/popup = new(user, "admin_adminhelps", "Adminhelps", 800, 400, src)
	popup.set_content(content)
	popup.open()

/datum/admin_secret_item/investigation/adminhelps/proc/on_adminhelp()
	build_content()
	for(var/user in users)
		update_user(user)
/datum/admin_secret_item/investigation/adminhelps/proc/on_admindiscon(var/client/C)
	users -= C