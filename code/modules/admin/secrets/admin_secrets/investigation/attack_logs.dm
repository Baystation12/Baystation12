/datum/admin_secret_item/investigation/attack_logs
	name = "Attack Logs"

/datum/admin_secret_item/investigation/attack_logs/execute(var/mob/user, var/filter)
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
	dat += "<tr><th style='text-align:left;'>Time</th><th style='text-align:left;'>Attacker</th><th style='text-align:left;'>Intent</th><th style='text-align:left;'>Victim</th></tr>"

	for(var/datum/attack_log/al in attack_log_repository.attack_logs_)
		if(filter && !(al.attacker && al.attacker.client.ckey == filter || al.victim && al.victim.client.ckey == filter))
			continue

		dat += "<tr><td>[al.station_time]</td>"

		if(al.attacker)
			dat += "<td>[al.attacker.key_name(check_if_offline = FALSE)] <a HREF='?_src_=holder;adminplayerobservefollow=[al.attacker.ref]'>JMP</a> <a href='?src=\ref[src];filter=[al.attacker.client.ckey]'>F</a></td>"
		else
			dat += "<td></td>"

		dat += "<td>[al.intent]</td>"

		if(al.victim)
			dat += "<td>[al.victim.key_name(check_if_offline = FALSE)] <a HREF='?_src_=holder;adminplayerobservefollow=[al.victim.ref]'>JMP</a> <a href='?src=\ref[src];filter=[al.victim.client.ckey]'>F</a></td>"
		else
			dat += "<td></td>"

		dat += "</tr>"
		dat += "<tr><td colspan=4>[al.message]"
		if(al.location)
			dat += " <a HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[al.location.x];Y=[al.location.y];Z=[al.location.z]'>JMP</a>"
		dat += "</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "admin_attack_logs", "Attack Logs", 800, 400)
	popup.set_content(jointext(dat, null))
	popup.open()

/datum/admin_secret_item/investigation/attack_logs/Topic(href, href_list)
	. = ..()
	if(.)
		return
	execute(usr, href_list["filter"])
