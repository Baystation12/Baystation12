/datum/admin_secret_item/investigation/admin_pms
	name = "Admin PMs"

/datum/admin_secret_item/investigation/admin_pms/execute(var/mob/user, var/filter)
	. = ..()
	if(!.)
		return
	var/dat = list()
	dat += "<a href='?src=\ref[src];filter=[filter]'>Refresh</a> Filtering on: "
	if(filter)
		dat += " [filter] <a href='?src=\ref[src]'>Clear</a>"
	else
		dat += "None"
	dat += "<HR>"
	dat += "<table border='1' style='width:100%;border-collapse:collapse;'>"
	dat += "<tr><th style='text-align:left;'>Time</th><th style='text-align:left;'>Sender</th><th style='text-align:left;'>Receiver</th></tr>"

	for(var/datum/admin_privat_message/pm in admin_pm_repository.admin_pms_)
		var/datum/client_lite/sender = pm.sender
		var/datum/client_lite/receiver = pm.receiver

		if(filter && !(sender.ckey == filter || (receiver && receiver.ckey == filter)))
			continue

		if(receiver)
			dat += "<tr><td>[pm.station_time]</td><td>[sender.key_name(FALSE)] <a href='?src=\ref[src];filter=[html_encode(sender.ckey)]'>F</a></td><td>[receiver.key_name(FALSE)] <a href='?src=\ref[src];filter=[receiver.ckey]'>F</a></td></tr>"
		else
			dat += "<tr><td>[pm.station_time]</td><td>[sender.key_name(FALSE)] <a href='?src=\ref[src];filter=[html_encode(sender.ckey)]'>F</a></td><td></td></tr>"
		dat += "<tr><td colspan=3>[pm.message]</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "admin_ahelps", "Admin PMs", 800, 400)
	popup.set_content(jointext(dat, null))
	popup.open()

/datum/admin_secret_item/investigation/admin_pms/Topic(href, href_list)
	. = ..()
	if(.)
		return
	execute(usr, href_list["filter"])
