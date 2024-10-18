/datum/admin_secret_item/investigation/computer_logs
	name = "Computer Logs"
	var/list/filters_per_client

/datum/admin_secret_item/investigation/computer_logs/New()
	..()
	filters_per_client = list()

/datum/admin_secret_item/investigation/computer_logs/execute(mob/user)
	. = ..()
	if(!.)
		return
	var/dat = list()
	dat += "<a href='?src=\ref[src]'>Refresh</a>"
	dat += "<HR>"
	dat += "<table border='1' style='width:100%;border-collapse:collapse;'>"
	dat += "<tr><th style='text-align:left;'>Time</th><th style='text-align:left;'>User</th><th style='text-align:left;'>Command</th></tr>"

	for(var/log in computer_log_repository.computer_logs_)
		var/datum/computer_log/al = log

		dat += "<tr><td>[al.station_time]</td>"

		if(al.user)
			dat += "<td>[al.user.key_name(check_if_offline = FALSE)] <a HREF='?_src_=holder;adminplayeropts=[al.user.ref]'>PP</a></td>"

		dat += "<td colspan=5>[al.command]"
		if(al.location)
			dat += " <a style='text-align:right;' HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[al.location.x];Y=[al.location.y];Z=[al.location.z]'>JMP</a>"
		dat += "</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "computer_attack_logs", "Computer Logs", 800, 400)
	popup.set_content(jointext(dat, null))
	popup.open()
